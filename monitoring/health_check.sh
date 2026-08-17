#!/bin/bash
LOG_FILE="$HOME/Infrastructure-Lab/monitoring/health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
THRESHOLD=80

# Lấy CPU usage (lấy % đang dùng = 100 - % idle)
CPU_IDLE=$(top -bn1 | grep -oP '[0-9.]+(?=\s*id)')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc | cut -d'.' -f1)

# Lấy RAM usage (%)
RAM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

# Lấy Disk usage (%) của partition gốc /
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

# So sánh và ghi log
if [ "$CPU_USAGE" -gt "$THRESHOLD" ]; then
    echo "$TIMESTAMP - WARNING: CPU usage high: $CPU_USAGE%" >> "$LOG_FILE"
fi

if [ "$RAM_USAGE" -gt "$THRESHOLD" ]; then
    echo "$TIMESTAMP - WARNING: RAM usage high: $RAM_USAGE%" >> "$LOG_FILE"
fi

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "$TIMESTAMP - WARNING: Disk usage high: $DISK_USAGE%" >> "$LOG_FILE"
fi

# Nếu không có cảnh báo nào, ghi log OK
if [ "$CPU_USAGE" -le "$THRESHOLD" ] && [ "$RAM_USAGE" -le "$THRESHOLD" ] && [ "$DISK_USAGE" -le "$THRESHOLD" ]; then
    echo "$TIMESTAMP - OK: CPU=$CPU_USAGE% RAM=$RAM_USAGE% DISK=$DISK_USAGE%" >> "$LOG_FILE"
fi