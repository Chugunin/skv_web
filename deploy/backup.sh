#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/opt/skv_web"
BACKUP_DIR="$PROJECT_DIR/backups"

mkdir -p "$BACKUP_DIR"

TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
BACKUP_FILE="$BACKUP_DIR/postgres-$TIMESTAMP.dump"

echo "=== PostgreSQL backup ==="
echo "Target: $BACKUP_FILE"

docker exec skv-postgres sh -c '
  pg_dump \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -Fc \
    -f /tmp/skv-backup.dump
'

docker cp \
  skv-postgres:/tmp/skv-backup.dump \
  "$BACKUP_FILE"

docker exec skv-postgres rm -f /tmp/skv-backup.dump

echo "Backup created successfully:"
ls -lh "$BACKUP_FILE"

echo "Cleaning old backups..."

find "$BACKUP_DIR" \
  -maxdepth 1 \
  -type f \
  -name 'postgres-*.dump' \
  -printf '%T@ %p\n' \
  | sort -nr \
  | tail -n +11 \
  | cut -d' ' -f2- \
  | xargs -r rm -f

echo "Backup cleanup completed."
