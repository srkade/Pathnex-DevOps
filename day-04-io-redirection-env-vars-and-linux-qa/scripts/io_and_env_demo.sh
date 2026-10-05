#!/bin/bash
# Day 4: Demo script for I/O Redirection, Environment Variables & Shell Special Variables

LOG_DIR="/tmp/day4_demo"
mkdir -p "$LOG_DIR"

echo "=== 1. Testing Special Shell Variables ==="
echo "Script Name (\$0)        : $0"
echo "First Argument (\$1)     : ${1:-None}"
echo "Total Arguments (\$#)    : $#"
echo "Process ID (\$\$)         : $$"

echo ""
echo "=== 2. Testing Environment Variables ==="
export APP_STAGE="staging"
export DB_PORT="5432"
echo "APP_STAGE is set to       : $APP_STAGE"
echo "DB_PORT is set to         : $DB_PORT"

echo ""
echo "=== 3. Testing I/O Redirection ==="
# Overwrite stdout (>)
echo "Log initialized on $(date)" > "$LOG_DIR/app.log"

# Append stdout (>>)
echo "Second log line added." >> "$LOG_DIR/app.log"

# Redirect stderr to file (2>)
ls /nonexistent_directory_test 2> "$LOG_DIR/errors.log"

# Check exit status of previous command ($?)
LAST_STATUS=$?
echo "Exit status code of failed ls (\$?) : $LAST_STATUS"

# Redirect both stdout and stderr (&>)
ls -l "$LOG_DIR" &> "$LOG_DIR/combined.log"

echo ""
echo "=== Content of Generated Logs ==="
cat "$LOG_DIR/app.log"
echo "--- Errors Log ---"
cat "$LOG_DIR/errors.log"

echo ""
echo "Demo completed successfully!"
