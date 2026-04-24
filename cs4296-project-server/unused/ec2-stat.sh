#!/bin/bash

# Script to monitor CPU utilization and RAM usage using pidstat
# Results are saved to a CSV file with 1-second intervals
# No arguments required - just run: ./ec2-stat.sh

# Hardcoded configuration
OUTPUT_FILE="ec2-system-stats.csv"
INTERVAL=1

# Function to cleanup and exit gracefully
cleanup() {
    exit 0
}

# Trap Ctrl+C to cleanup gracefully
trap cleanup SIGINT

# Check if pidstat is available
if ! command -v pidstat &> /dev/null; then
    exit 1
fi

# Create CSV header
echo "Timestamp,CPU,RAM_MB" > "$OUTPUT_FILE"

# Main monitoring loop
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Track all uvicorn processes (single worker or multi-worker).
    UVICORN_PIDS=$(pgrep -f "uvicorn" | paste -sd, -)

    if [ -z "$UVICORN_PIDS" ]; then
        sleep "$INTERVAL"
        continue
    fi

    CPU_SAMPLE=$(pidstat -u -p "$UVICORN_PIDS" "$INTERVAL" 1 2>/dev/null)
    RAM_SAMPLE=$(pidstat -r -p "$UVICORN_PIDS" "$INTERVAL" 1 2>/dev/null)

    CPU_TOTAL=$(echo "$CPU_SAMPLE" | awk '
        /^Average:/ && $3 ~ /^[0-9]+$/ {sum += $8; count++}
        END {if (count > 0) printf "%.2f", sum}
    ')

    RAM_KB_TOTAL=$(echo "$RAM_SAMPLE" | awk '
        /^Average:/ && $3 ~ /^[0-9]+$/ {sum += $7; count++}
        END {if (count > 0) printf "%.0f", sum}
    ')

    if [ -n "$CPU_TOTAL" ] && [ -n "$RAM_KB_TOTAL" ]; then
        RAM_MB=$(awk -v kb="$RAM_KB_TOTAL" 'BEGIN {printf "%.2f", kb / 1024}')
        echo "$TIMESTAMP,$CPU_TOTAL,$RAM_MB" >> "$OUTPUT_FILE"
    fi
done







