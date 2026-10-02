#!/bin/bash
# Day 1: Simple system health check script

echo "----------------------------------------"
echo "        SYSTEM INFORMATION REPORT       "
echo "----------------------------------------"

echo "[1] Hostname & User:"
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"

echo ""
echo "[2] System Uptime:"
uptime

echo ""
echo "[3] OS & Kernel Version:"
uname -s -r -v

echo ""
echo "[4] Memory Usage:"
free -h

echo ""
echo "[5] Disk Space Usage:"
df -h /

echo "----------------------------------------"
echo "Report Done."
