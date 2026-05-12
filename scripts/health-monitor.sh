#!/bin/bash

#LOG_FILE="/var/log/statuspulse-monitor.log"
LOG_FILE="/var/log/statuspulse/monitor.log"
echo "$(date) - Starting health check" >> $LOG_FILE

# API check
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health)

if [ "$HTTP_CODE" != "200" ]; then
  ./scripts/alert.sh "ALERT: StatusPulse API DOWN"
  echo "$(date) - API DOWN" >> $LOG_FILE
fi

# Disk usage
DISK=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $DISK -gt 80 ]; then
  ./scripts/alert.sh "ALERT: Disk usage high: $DISK%"
  echo "$(date) - Disk warning $DISK%" >> $LOG_FILE
fi

# Memory usage
MEM=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

if [ $MEM -gt 90 ]; then
  ./scripts/alert.sh "ALERT: Memory usage high: $MEM%"
  echo "$(date) - Memory warning $MEM%" >> $LOG_FILE
fi

echo "$(date) - Health check completed" >> $LOG_FILE


notify() {
  curl -d "$1" https://ntfy.sh/statuspulse-alerts-anand
}
