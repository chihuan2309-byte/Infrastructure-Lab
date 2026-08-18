#!/bin/bash

DB_PATH="/var/lib/docker/volumes/it-asset-manager_asset_data/_data/assets.db"
BACKUP_DIR="$HOME/Infrastructure-Lab/backup/backups"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.db"
LOG_FILE="$HOME/Infrastructure-Lab/backup/backup.log"
RETENTION_DAYS=7

# Load Telegram credentials
source "$HOME/Infrastructure-Lab/.env"

send_telegram_alert() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${message}" > /dev/null
}

mkdir -p "$BACKUP_DIR"

TIMESTAMP_LOG=$(date '+%Y-%m-%d %H:%M:%S')

sudo sqlite3 "$DB_PATH" ".backup '$BACKUP_FILE'"

if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ]; then
    gzip "$BACKUP_FILE"
    echo "$TIMESTAMP_LOG - SUCCESS: Backup created at ${BACKUP_FILE}.gz" >> "$LOG_FILE"
else
    echo "$TIMESTAMP_LOG - FAILED: Backup failed" >> "$LOG_FILE"
    send_telegram_alert "🔴 [$(hostname)] Database backup FAILED at $TIMESTAMP_LOG"
    exit 1
fi

find "$BACKUP_DIR" -name "backup_*.db.gz" -mtime +$RETENTION_DAYS -delete

echo "$TIMESTAMP_LOG - INFO: Old backups cleaned (older than ${RETENTION_DAYS} days)" >> "$LOG_FILE"