#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/opt/skv_web"
SOURCE_DIR="$PROJECT_DIR/data/directus/uploads"
BACKUP_DIR="$PROJECT_DIR/backups/uploads"

mkdir -p "$BACKUP_DIR"

TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
BACKUP_FILE="$BACKUP_DIR/uploads-$TIMESTAMP.tar.gz"

echo "=== Directus uploads backup ==="

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Uploads directory does not exist:"
  echo "$SOURCE_DIR"
  exit 0
fi

tar \
  -C "$PROJECT_DIR/data/directus" \
  -czf "$BACKUP_FILE" \
  uploads

echo "Created:"
ls -lh "$BACKUP_FILE"

echo "Cleaning old uploads backups..."

find "$BACKUP_DIR" \
  -maxdepth 1 \
  -type f \
  -name 'uploads-*.tar.gz' \
  -printf '%T@ %p\n' \
  | sort -nr \
  | tail -n +11 \
  | cut -d' ' -f2- \
  | xargs -r rm -f

echo "Uploads backup completed."