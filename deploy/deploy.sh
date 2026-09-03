#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/opt/skv_web"
DEPLOY_STATE_DIR="$PROJECT_DIR/data/deploy"
LAST_COMMIT_FILE="$DEPLOY_STATE_DIR/.last-successful-commit"

cd "$PROJECT_DIR"
mkdir -p "$DEPLOY_STATE_DIR"

CURRENT_COMMIT="$(git rev-parse HEAD)"
LAST_COMMIT="$(cat "$LAST_COMMIT_FILE" 2>/dev/null || true)"
DEPLOY_MODE="FULL"
CHANGED_FILES=""

log_changed_files() {
  if [ -n "$CHANGED_FILES" ]; then
    echo "Changed files since last successful deploy:"
    printf '%s\n' "$CHANGED_FILES" | sed 's/^/  - /'
  else
    echo "Changed files since last successful deploy: none"
  fi
}

classify_deploy() {
  local override="${SKV_DEPLOY_MODE:-auto}"

  case "$override" in
    full|FULL)
      DEPLOY_MODE="FULL"
      echo "Deploy mode overridden by SKV_DEPLOY_MODE=full"
      return
      ;;
    web|WEB)
      DEPLOY_MODE="WEB"
      echo "Deploy mode overridden by SKV_DEPLOY_MODE=web"
      return
      ;;
    web-deps|WEB_WITH_DEPS|web_with_deps)
      DEPLOY_MODE="WEB_WITH_DEPS"
      echo "Deploy mode overridden by SKV_DEPLOY_MODE=web-deps"
      return
      ;;
    auto|AUTO|"")
      ;;
    *)
      echo "ERROR: unsupported SKV_DEPLOY_MODE='$override'."
      echo "Allowed values: auto, full, web, web-deps."
      exit 2
      ;;
  esac

  if [ -z "$LAST_COMMIT" ]; then
    echo "No previous successful deploy commit recorded."
    DEPLOY_MODE="FULL"
    return
  fi

  if ! git cat-file -e "${LAST_COMMIT}^{commit}" 2>/dev/null; then
    echo "Previous deploy commit '$LAST_COMMIT' is not available locally."
    DEPLOY_MODE="FULL"
    return
  fi

  if ! git merge-base --is-ancestor "$LAST_COMMIT" "$CURRENT_COMMIT" 2>/dev/null; then
    echo "Git history is not linear from the previous successful deploy."
    echo "Falling back to FULL deploy."
    DEPLOY_MODE="FULL"
    return
  fi

  CHANGED_FILES="$(git diff --name-only "$LAST_COMMIT" "$CURRENT_COMMIT")"

  if [ -z "$CHANGED_FILES" ]; then
    DEPLOY_MODE="NOOP"
    return
  fi

  # Fast deploy is deliberately allowed only for changes contained in web/.
  # Any change outside web/ is treated conservatively as infrastructure/CMS
  # and therefore receives the existing full deployment procedure.
  if printf '%s\n' "$CHANGED_FILES" | grep -qv '^web/'; then
    DEPLOY_MODE="FULL"
    return
  fi

  if printf '%s\n' "$CHANGED_FILES" | grep -Eq '^web/(package\.json|package-lock\.json)$'; then
    DEPLOY_MODE="WEB_WITH_DEPS"
  else
    DEPLOY_MODE="WEB"
  fi
}

record_successful_commit() {
  printf '%s\n' "$CURRENT_COMMIT" > "$LAST_COMMIT_FILE"
  echo "Recorded successful deploy commit: $CURRENT_COMMIT"
}

wait_for_postgres() {
  echo "Waiting for PostgreSQL..."

  until docker exec skv-postgres \
    pg_isready \
    -U "$(docker exec skv-postgres printenv POSTGRES_USER)" \
    -d "$(docker exec skv-postgres printenv POSTGRES_DB)" \
    >/dev/null 2>&1
  do
    sleep 2
  done

  echo "PostgreSQL is ready."
}

wait_for_directus() {
  echo "Waiting for Directus..."

  local ready=false

  for _ in $(seq 1 60); do
    if curl -fsS http://127.0.0.1:8055/server/ping >/dev/null 2>&1; then
      ready=true
      echo "Directus is ready."
      break
    fi
    sleep 2
  done

  if [ "$ready" != "true" ]; then
    echo "ERROR: Directus failed readiness check."
    docker compose logs --tail=100 directus || true
    exit 1
  fi
}

build_astro() {
  echo "Building Astro..."

  if ! timeout 20m \
    docker compose \
      --profile build \
      run \
      --rm \
      -T \
      astro-build
  then
    echo "ERROR: Astro build failed or timed out."
    exit 1
  fi
}

save_web_rollback() {
  echo "Saving current web image..."

  if docker image inspect skv-web:latest >/dev/null 2>&1; then
    docker tag skv-web:latest skv-web:rollback
    echo "Previous image saved as skv-web:rollback."
  else
    echo "No previous web image found."
    echo "This appears to be the first deployment."
  fi
}

build_web_image() {
  echo "Building web image..."

  if ! docker compose build web; then
    echo "ERROR: Web image build failed."
    exit 1
  fi
}

wait_for_web() {
  local label="${1:-Web}"
  local ready=false
  local status=""

  echo "Waiting for ${label,,} health check..."

  for _ in $(seq 1 30); do
    status="$(
      docker inspect \
        --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
        skv-web \
        2>/dev/null \
        || true
    )"

    echo "$label status: $status"

    if [ "$status" = "healthy" ]; then
      if curl -fsS http://127.0.0.1:4321/ >/dev/null 2>&1; then
        ready=true
        break
      else
        echo "Container reports healthy, but HTTP check failed."
      fi
    fi

    if [ "$status" = "unhealthy" ]; then
      break
    fi

    sleep 2
  done

  [ "$ready" = "true" ]
}

deploy_web_with_rollback() {
  save_web_rollback
  build_web_image

  echo "Deploying web..."
  docker compose up -d web

  if wait_for_web "Web"; then
    return 0
  fi

  echo
  echo "ERROR: New web deployment failed health check."
  echo
  docker compose logs --tail=100 web || true

  if docker image inspect skv-web:rollback >/dev/null 2>&1; then
    echo
    echo "Rolling back to previous web image..."

    docker rm -f skv-web >/dev/null 2>&1 || true
    docker tag skv-web:rollback skv-web:latest
    docker compose up -d --force-recreate web

    echo
    if wait_for_web "Rollback web"; then
      echo "Rollback completed successfully."
    else
      echo "CRITICAL: rollback container is not healthy."
    fi

    echo
    echo "WARNING:"
    echo "Frontend was rolled back."
    echo "Directus schema was NOT rolled back."
    echo "PostgreSQL backup is available in:"
    echo "$PROJECT_DIR/backups"
  else
    echo
    echo "CRITICAL: no rollback image is available."
  fi

  exit 1
}

final_health_checks() {
  echo
  echo "=== Final health checks ==="

  if ! curl -fsS http://127.0.0.1:8055/server/ping >/dev/null; then
    echo "ERROR: Directus final health check failed."
    exit 1
  fi
  echo "Directus: OK"

  if ! curl -fsS http://127.0.0.1:4321/ >/dev/null; then
    echo "ERROR: Web final HTTP check failed."
    exit 1
  fi
  echo "Web: OK"

  echo
  echo "=== Containers ==="
  docker compose ps
}

run_full_deploy() {
  echo "[FULL 1/11] Starting database..."
  docker compose up -d postgres

  echo "[FULL 2/11] PostgreSQL readiness..."
  wait_for_postgres

  echo "[FULL 3/11] Creating database backup..."
  bash "$PROJECT_DIR/deploy/backup.sh"

  echo "[FULL 4/11] Creating Directus uploads backup..."
  bash "$PROJECT_DIR/deploy/backup-uploads.sh"

  echo "[FULL 5/11] Starting Directus..."
  docker compose up -d directus

  echo "[FULL 6/11] Directus readiness..."
  wait_for_directus

  echo "[FULL 7/11] Applying Directus schema..."
  local schema_file="$PROJECT_DIR/directus/schema/schema.yaml"

  if [ -f "$schema_file" ]; then
    docker compose exec -T directus \
      node cli.js schema apply \
      --yes \
      /directus/schema/schema.yaml
    echo "Directus schema applied successfully."
  else
    echo "No Directus schema snapshot found. Skipping schema apply."
  fi

  echo "[FULL 8/11] Astro build..."
  build_astro

  echo "[FULL 9/11] Saving rollback image..."
  save_web_rollback

  echo "[FULL 10/11] Building web image..."
  build_web_image

  echo "[FULL 11/11] Deploying web..."
  # The image was already saved and built above, so perform deployment and
  # rollback handling inline without saving/building a second time.
  docker compose up -d web

  if ! wait_for_web "Web"; then
    echo
    echo "ERROR: New web deployment failed health check."
    docker compose logs --tail=100 web || true

    if docker image inspect skv-web:rollback >/dev/null 2>&1; then
      echo "Rolling back to previous web image..."
      docker rm -f skv-web >/dev/null 2>&1 || true
      docker tag skv-web:rollback skv-web:latest
      docker compose up -d --force-recreate web

      if wait_for_web "Rollback web"; then
        echo "Rollback completed successfully."
      else
        echo "CRITICAL: rollback container is not healthy."
      fi

      echo "WARNING: Directus schema was NOT rolled back."
      echo "PostgreSQL backup is available in $PROJECT_DIR/backups"
    else
      echo "CRITICAL: no rollback image is available."
    fi

    exit 1
  fi
}

run_web_deploy() {
  echo "[WEB 1/5] Ensuring PostgreSQL and Directus are running..."
  docker compose up -d postgres directus

  echo "[WEB 2/5] Waiting for Directus..."
  wait_for_directus

  if [ "$DEPLOY_MODE" = "WEB_WITH_DEPS" ]; then
    echo "[WEB 3/5] Building Astro (dependency hash changed; npm ci will run)..."
  else
    echo "[WEB 3/5] Building Astro (dependencies unchanged; npm ci should be skipped)..."
  fi
  build_astro

  echo "[WEB 4/5] Building and deploying frontend with rollback protection..."
  deploy_web_with_rollback

  echo "[WEB 5/5] Frontend deployment completed."
}

echo "=== SKV deploy started ==="
echo "Current commit: $CURRENT_COMMIT"
echo "Previous successful commit: ${LAST_COMMIT:-none}"

classify_deploy
log_changed_files

echo
echo "Selected deploy mode: $DEPLOY_MODE"
echo

case "$DEPLOY_MODE" in
  FULL)
    run_full_deploy
    ;;
  WEB|WEB_WITH_DEPS)
    run_web_deploy
    ;;
  NOOP)
    echo "No repository changes since the last successful deploy."
    echo "Deployment skipped."
    record_successful_commit
    exit 0
    ;;
  *)
    echo "ERROR: internal unsupported deploy mode '$DEPLOY_MODE'."
    exit 2
    ;;
esac

final_health_checks
record_successful_commit

echo
echo "=== SKV deploy completed successfully ($DEPLOY_MODE) ==="
