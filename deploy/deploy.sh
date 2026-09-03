#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/opt/skv_web"
BRANCH="master"

cd "$PROJECT_DIR"

echo "=== SKV deploy started ==="

echo "[1/11] Updating repository..."

git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

echo "[2/11] Starting database..."

docker compose up -d postgres

echo "[3/11] Waiting for PostgreSQL..."

until docker exec skv-postgres \
  pg_isready \
  -U "$(docker exec skv-postgres printenv POSTGRES_USER)" \
  -d "$(docker exec skv-postgres printenv POSTGRES_DB)" \
  >/dev/null 2>&1
do
  sleep 2
done

echo "PostgreSQL is ready."

echo "[4/11] Creating database backup..."

bash "$PROJECT_DIR/deploy/backup.sh"

echo "[5/11] Starting Directus..."

docker compose up -d directus

echo "[6/11] Waiting for Directus..."

DIRECTUS_READY=false

for i in $(seq 1 60); do

  if curl -fsS \
    http://127.0.0.1:8055/server/ping \
    >/dev/null 2>&1
  then
    DIRECTUS_READY=true
    echo "Directus is ready."
    break
  fi

  sleep 2
done

if [ "$DIRECTUS_READY" != "true" ]; then

  echo "ERROR: Directus failed readiness check."

  docker compose logs \
    --tail=100 \
    directus || true

  exit 1
fi

echo "[7/11] Applying Directus schema..."

SCHEMA_FILE="$PROJECT_DIR/directus/schema/schema.yaml"

if [ -f "$SCHEMA_FILE" ]; then

  docker compose exec -T directus \
    node cli.js schema apply \
    --yes \
    /directus/schema/schema.yaml

  echo "Directus schema applied successfully."

else

  echo "No Directus schema snapshot found."
  echo "Skipping schema apply."

fi

echo "[8/11] Building Astro..."

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

echo "[9/11] Saving current web image..."

if docker image inspect \
  skv-web:latest \
  >/dev/null 2>&1
then

  docker tag \
    skv-web:latest \
    skv-web:rollback

  echo "Previous image saved as skv-web:rollback."

else

  echo "No previous web image found."
  echo "This appears to be the first deployment."

fi

echo "[10/11] Building web image..."

if ! docker compose build web; then

  echo "ERROR: Web image build failed."

  exit 1
fi

echo "[11/11] Deploying web..."

docker compose up -d web

echo "Waiting for web health check..."

WEB_READY=false

for i in $(seq 1 30); do

  STATUS="$(
    docker inspect \
      --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
      skv-web \
      2>/dev/null \
      || true
  )"

  echo "Web status: $STATUS"

  if [ "$STATUS" = "healthy" ]; then

    if curl -fsS \
      http://127.0.0.1:4321/ \
      >/dev/null 2>&1
    then

      WEB_READY=true
      break

    else

      echo "Container reports healthy, but HTTP check failed."

    fi

  fi

  if [ "$STATUS" = "unhealthy" ]; then
    break
  fi

  sleep 2
done

if [ "$WEB_READY" != "true" ]; then

  echo
  echo "ERROR: New web deployment failed health check."
  echo

  docker compose logs \
    --tail=100 \
    web \
    || true

  if docker image inspect \
    skv-web:rollback \
    >/dev/null 2>&1
  then

    echo
    echo "Rolling back to previous web image..."

    docker rm \
      -f \
      skv-web \
      >/dev/null 2>&1 \
      || true

    docker tag \
      skv-web:rollback \
      skv-web:latest

    docker compose up \
      -d \
      --force-recreate \
      web

    echo "Waiting for rollback health check..."

    ROLLBACK_READY=false

    for i in $(seq 1 30); do

      STATUS="$(
        docker inspect \
          --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' \
          skv-web \
          2>/dev/null \
          || true
      )"

      echo "Rollback web status: $STATUS"

      if [ "$STATUS" = "healthy" ]; then

        if curl -fsS \
          http://127.0.0.1:4321/ \
          >/dev/null 2>&1
        then

          ROLLBACK_READY=true
          break

        fi

      fi

      if [ "$STATUS" = "unhealthy" ]; then
        break
      fi

      sleep 2
    done

    echo

    if [ "$ROLLBACK_READY" = "true" ]; then

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
fi

echo
echo "=== Final health checks ==="

if ! curl -fsS \
  http://127.0.0.1:8055/server/ping \
  >/dev/null
then

  echo "ERROR: Directus final health check failed."

  exit 1
fi

echo "Directus: OK"

if ! curl -fsS \
  http://127.0.0.1:4321/ \
  >/dev/null
then

  echo "ERROR: Web final HTTP check failed."

  exit 1
fi

echo "Web: OK"

echo
echo "=== Containers ==="

docker compose ps

echo
echo "=== SKV deploy completed successfully ==="