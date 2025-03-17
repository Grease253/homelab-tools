#!/bin/bash

# Configuration
BACKUP_DIR="/home/pie5/backups"

# List available backups
BACKUPS=$(ls -t "$BACKUP_DIR/backup_*.tar.gz")
NUM_BACKUPS=$(echo "$BACKUPS" | wc -l)

if [ "$NUM_BACKUPS" -eq 0 ]; then
    echo "No backups found in $BACKUP_DIR."
    exit 1
fi

# Display menu
echo "Available Backups:"
select BACKUP in $BACKUPS; do
    if [ -n "$BACKUP" ]; then
        break
    else
        echo "Invalid selection."
    fi
done

# Prompt for restore type
echo "Restore options:"
echo "1. Restore entire backup"
echo "2. Restore single file"
echo "3. List backup contents"
read -p "Enter your choice (1, 2, or 3): " choice

case "$choice" in
    1)
        # Restore entire backup
        read -p "Enter the restore directory (e.g., /home/pie5/restored_files): " RESTORE_DIR
        if [ ! -d "$RESTORE_DIR" ]; then
            mkdir -p "$RESTORE_DIR"
        fi

        echo "Restoring entire backup to $RESTORE_DIR..."
        sudo tar -xzf "$BACKUP" -C "$RESTORE_DIR" -v #added verbose output
        if [ $? -eq 0 ]; then
            echo "Restore complete."
        else
            echo "Restore failed."
        fi
        ;;
    2)
        # Restore single file
        read -p "Enter the path to the file you want to restore (as it appears in the backup): " FILE_PATH
        read -p "Enter the restore directory: " RESTORE_DIR
        if [ ! -d "$RESTORE_DIR" ]; then
            mkdir -p "$RESTORE_DIR"
        fi
        echo "Restoring $FILE_PATH to $RESTORE_DIR..."
        sudo tar -xzf "$BACKUP" "$FILE_PATH" -C "$RESTORE_DIR" -v #added verbose output
        if [ $? -eq 0 ]; then
            echo "File restored."
        else
            echo "File restore failed."
        fi
        ;;
    3)
        # List backup contents
        tar -tzf "$BACKUP"
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
