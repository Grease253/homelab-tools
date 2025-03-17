#!/bin/bash

LOG_FILE="/home/pie5/logs/pi_health.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting pi_health.sh" >> "$LOG_FILE"

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed -E "s/.*id[ ,]*([0-9.]+)%.*/\1/")
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: top/grep/sed failed (CPU Usage)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - CPU Usage: $CPU_USAGE" >> "$LOG_FILE"

# Memory Usage
MEMORY_TOTAL=$(free -m | awk 'NR==2{print $2}')
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: free/awk failed (Memory Total)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - Memory Total: $MEMORY_TOTAL" >> "$LOG_FILE"

MEMORY_USED=$(free -m | awk 'NR==2{print $3}')
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: free/awk failed (Memory Used)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - Memory Used: $MEMORY_USED" >> "$LOG_FILE"

MEMORY_PERCENT=$((MEMORY_USED * 100 / MEMORY_TOTAL))
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Arithmetic calculation failed (Memory Percent)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - Memory Percent: $MEMORY_PERCENT" >> "$LOG_FILE"

# Disk Usage
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: df/awk/sed failed (Disk Usage)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - Disk Usage: $DISK_USAGE" >> "$LOG_FILE"

# Network Connectivity
if ping -c 1 google.com > /dev/null 2>&1; then
    NETWORK_STATUS="Online"
else
    NETWORK_STATUS="Offline"
fi
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: ping failed (Network Connectivity)" >> "$LOG_FILE"
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') - Network Status: $NETWORK_STATUS" >> "$LOG_FILE"

# Display Results
echo "System Health Check:"
echo "--------------------"
echo "CPU Usage: $CPU_USAGE%"
echo "Memory Usage: $MEMORY_USED/$MEMORY_TOTAL MB ($MEMORY_PERCENT%)"
echo "Disk Usage: $DISK_USAGE%"
echo "Network Status: $NETWORK_STATUS"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Script completed successfully" >> "$LOG_FILE"

sleep 10
