#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/opt/skv_web"
BRANCH="master"

cd "$PROJECT_DIR"

echo "=== SKV deploy started ==="

echo "[1/10] Updating repository..."
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

echo "[2/10] Starting database..."
docker compose up -d postgres

echo "[3/10] Waiting for PostgreSQL..."

until docker exec skv-postgres \
  pg_isready \
  -U "$(docker exec skv-postgres printenv POSTGRES_USER)" \
  -d "$(docker exec skv-postgres printenv POSTGRES_DB)" \
  >/dev/null 2>&1
do
  sleep 2
done

echo "[4/10] Creating database backup..."
"$PROJECT_DIR/deploy/backup.sh"

echo "[5/10] Starting Directus..."
docker compose up -d directus

echo "[6/10] Waiting for Directus..."

DIRECTUS_READY=false

for i in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:8055/server/ping >/dev/null 2>&1; then
    DIRECTUS_READY=true
    echo "Directus is ready."
    break
  fi

  sleep 2
done

if [ "$DIRECTUS_READY" != "true" ]; then
  echo "Directus failed readiness check."
  docker compose logs --tail=100 directus
  exit 1
fi

echo "[7/10] Applying Directus schema..."

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

echo "[8/10] Building Astro..."

docker compose --profile build run --rm -T astro-build

echo "[9/10] Building web image..."

docker compose build web

echo "[10/10] Deploying..."

docker compose up -d web
docker compose up -d --remove-orphans

echo
echo "=== Containers ==="
docker compose ps

echo
echo "=== SKV deploy completed successfully ==="
