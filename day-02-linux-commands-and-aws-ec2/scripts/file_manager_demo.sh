#!/bin/bash
# Day 2: Script to practice file creation and permissions

# Target test directory
LAB_DIR="/tmp/devops_practice"

echo "=== Setting up practice directory at $LAB_DIR ==="
mkdir -p "$LAB_DIR/config" "$LAB_DIR/scripts" "$LAB_DIR/logs"

# Create sample files
touch "$LAB_DIR/config/db.env"
touch "$LAB_DIR/scripts/backup.sh"
touch "$LAB_DIR/logs/app.log"

echo "Files created:"
ls -l "$LAB_DIR"

echo ""
echo "=== Applying permissions ==="
# 755 for scripts (executable)
chmod 755 "$LAB_DIR/scripts/backup.sh"

# 600 for secret env file (owner read-write only)
chmod 600 "$LAB_DIR/config/db.env"

# 644 for log file
chmod 644 "$LAB_DIR/logs/app.log"

echo "Updated permissions:"
ls -l "$LAB_DIR/scripts" "$LAB_DIR/config" "$LAB_DIR/logs"

echo "Done!"
