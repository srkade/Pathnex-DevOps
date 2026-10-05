#!/bin/bash
# Day 4: Automated directory backup demonstration script using rsync

SRC_DIR="/tmp/day4_source"
DEST_DIR="/tmp/day4_backup"

echo "=== Preparing source data ==="
mkdir -p "$SRC_DIR" "$DEST_DIR"
echo "Application Config v1" > "$SRC_DIR/config.env"
echo "User Assets Data" > "$SRC_DIR/data.txt"

echo "=== Step 1: Performing Dry-Run (Simulation) ==="
rsync -av --dry-run "$SRC_DIR/" "$DEST_DIR/"

echo ""
echo "=== Step 2: Executing Actual Sync with Archive Flags (-av) ==="
rsync -av "$SRC_DIR/" "$DEST_DIR/"

echo ""
echo "=== Step 3: Verifying Backup Contents ==="
ls -la "$DEST_DIR"

echo ""
echo "Backup synchronization complete!"
