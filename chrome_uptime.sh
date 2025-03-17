#!/bin/bash

# Configuration
MONITORED_HOST="10.0.0.36" # Host to monitor
LOG_FILE="/home/pie5/logs/chrome_uptime.log" # Log file path
INTERVAL=60 # Check interval in seconds

# Function to check host availability
check_host() {
  if ping -c 1 "$MONITORED_HOST" > /dev/null 2>&1; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $MONITORED_HOST is up" >> "$LOG_FILE"
    return 0
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $MONITORED_HOST is down" >> "$LOG_FILE"
    return 1
  fi
}

# Main loop
while true; do
  check_host
  sleep "$INTERVAL"
done
