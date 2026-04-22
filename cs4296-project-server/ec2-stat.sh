#!/bin/bash

# Script to monitor CPU utilization and RAM usage using pidstat
# Results are saved to a CSV file with 1-second intervals
# No arguments required - just run: ./ec2-stat.sh

# Hardcoded configuration
OUTPUT_FILE="ec2_system_stats.csv"
INTERVAL=1

# Function to cleanup and exit gracefully
cleanup() {
    exit 0
}

# Trap Ctrl+C to cleanup gracefully
trap cleanup SIGINT

# Check if pidstat is available
if ! command -v pidstat &> /dev/null; then
    echo "Error: pidstat not found. Please install sysstat package:"
    echo "  On Ubuntu/Debian: sudo apt-get install sysstat"
    exit 1
fi

# Create CSV header
echo "Timestamp,%CPU,RAM_MB" > "$OUTPUT_FILE"

# Main monitoring loop
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Find uvicorn process PID
    UVICORN_PID=$(pgrep -f "uvicorn" | head -1)
    
    if [ -z "$UVICORN_PID" ]; then
        sleep "$INTERVAL"
        continue
    fi
    
    # Get CPU and memory stats for the specific uvicorn process
    STATS=$(pidstat -u -r 1 1 -p "$UVICORN_PID" 2>/dev/null | grep "^$UVICORN_PID" | head -1)
    
    if [ -n "$STATS" ]; then
        # Extract CPU usage (%CPU is typically at position 8 for pidstat -u output)
        CPU=$(echo "$STATS" | awk '{print $8}')
        
        # Extract RAM usage (RSS in KB is typically at position 6 for pidstat -r output, then convert to MB)
        RAM_KB=$(echo "$STATS" | awk '{print $6}')
        RAM_MB=$((RAM_KB / 1024))
        
        # Write to CSV file only if we have valid data
        if [ -n "$CPU" ] && [ -n "$RAM_MB" ]; then
            echo "$TIMESTAMP,$CPU,$RAM_MB" >> "$OUTPUT_FILE"
        fi
    fi
    
    sleep "$INTERVAL"
done







