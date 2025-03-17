#!/bin/bash

# Configuration
BACKUP_DIR="/home/pie5/backups/"
SOURCE_DIRS=("/etc/" "/var/www/" "/srv/www/" "/var/lib/" "/opt/" "/boot/" "/docker/")
NUM_BACKUPS_TO_KEEP=10
LOG_FILE="$BACKUP_DIR/backup_errors.log"

# Function to check directory existence and permissions
check_directory() {
    if [ ! -d "$1" ]; then
        echo "Error: Directory '$1' does not exist." >> "$LOG_FILE"
        return 1
    elif [ ! -r "$1" ]; then
        echo "Error: Directory '$1' is not readable." >> "$LOG_FILE"
        return 1
    else
        return 0
    fi
}

# Check backup directory
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Could not create backup directory '$BACKUP_DIR'."
        exit 1
    fi
fi

# Create timestamped backup
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Backup directories
VALID_DIRS=()
for DIR in "${SOURCE_DIRS[@]}"; do
    if check_directory "$DIR"; then
        echo "Skipping directory: $DIR"
        continue
    fi
    VALID_DIRS+=("$DIR")
done

# Create the tar archive with valid directories, ignoring errors
if [ ${#VALID_DIRS[@]} -gt 0 ]; then
    tar --ignore-failed-read -czvf "$BACKUP_FILE" "${VALID_DIRS[@]}" 2>> "$LOG_FILE"
else
    echo "Error: No valid directories to backup." >> "$LOG_FILE"
    exit 1
fi

# Backup Rotation
BACKUPS=$(ls -tr "$BACKUP_DIR/backup_*.tar.gz" 2>/dev/null)
BACKUP_COUNT=$(echo "$BACKUPS" | wc -l)

if [ "$BACKUP_COUNT" -gt "$NUM_BACKUPS_TO_KEEP" ]; then
    OLDEST_BACKUP=$(echo "$BACKUPS" | head -n $((BACKUP_COUNT - NUM_BACKUPS_TO_KEEP)))
    for BACKUP in $OLDEST_BACKUP; do
        rm "$BACKUP"
    done
fi
