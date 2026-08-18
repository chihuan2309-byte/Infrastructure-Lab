#!/bin/bash

BACKUP_DIR="$HOME/Infrastructure-Lab/backup/backups"
LOG_FILE="$HOME/Infrastructure-Lab/backup/backup.log"
GDRIVE_REMOTE="Gdrivebackup:infrastructure-lab-backups"

source "$HOME/Infrastructure-Lab/.env"

send_telegram_alert() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${message}" > /dev/null
}

TIMESTAMP_LOG=$(date '+%Y-%m-%d %H:%M:%S')

# Tìm file backup mới nhất trong thư mục (theo thời gian sửa đổi)
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup_*.db.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "$TIMESTAMP_LOG - FAILED: No backup file found to sync" >> "$LOG_FILE"
    send_telegram_alert "🔴 [$(hostname)] No backup file found for weekly Google Drive sync"
    exit 1
fi

rclone copy "$LATEST_BACKUP" "$GDRIVE_REMOTE" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "$TIMESTAMP_LOG - SUCCESS: Synced $LATEST_BACKUP to Google Drive" >> "$LOG_FILE"
else
    echo "$TIMESTAMP_LOG - WARNING: Failed to sync $LATEST_BACKUP to Google Drive" >> "$LOG_FILE"
    send_telegram_alert "⚠️ [$(hostname)] Weekly Google Drive sync FAILED"
fi