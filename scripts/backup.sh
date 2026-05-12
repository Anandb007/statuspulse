#!/bin/bash

set -e

BACKUP_DIR="/opt/statuspulse-backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p $BACKUP_DIR

echo "[INFO] Starting DB backup at $TIMESTAMP"

docker exec postgres pg_dump -U statuspulse statuspulse | gzip > $BACKUP_DIR/statuspulse_db_$TIMESTAMP.sql.gz

echo "[INFO] Backup created: statuspulse_db_$TIMESTAMP.sql.gz"

# Keep only last 7 backups
cd $BACKUP_DIR
ls -t | tail -n +8 | xargs -r rm --

echo "[INFO] Old backups cleaned (kept last 7)"
