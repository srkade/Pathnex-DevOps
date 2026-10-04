#!/bin/bash
# Day 3: Process check, disk usage alert, and network verification script

SERVICE="nginx"

echo "=========================================="
echo "    DAY 3: SYSTEM MONITOR & HEALTH CHECK  "
echo "=========================================="

# 1. Check if a service/process is running using pgrep
echo ""
echo "[1] Process Check:"
if pgrep "$SERVICE" > /dev/null; then
    echo " -> Process '$SERVICE' is RUNNING (PID: $(pgrep -d ',' "$SERVICE"))"
else
    echo " -> Process '$SERVICE' is NOT running."
fi

# 2. Check Disk Space with df and du
echo ""
echo "[2] Disk Space & Directory Size:"
df -h /
echo "Size of current directory:"
du -sh .

# 3. Check open ports using ss
echo ""
echo "[3] Listening TCP Ports:"
if command -v ss > /dev/null; then
    ss -tuln | head -n 10
elif command -v netstat > /dev/null; then
    netstat -tuln | head -n 10
else
    echo "Neither ss nor netstat available."
fi

# 4. Check Internet Connectivity with ping and curl
echo ""
echo "[4] Network Connectivity:"
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo " -> Internet Connection: ACTIVE"
else
    echo " -> Internet Connection: FAILED"
fi

echo "=========================================="
