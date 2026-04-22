#!/usr/bin/env bash

# Installation: pidstat is part of the sysstat package
# Ubuntu/Debian: sudo apt-get update && sudo apt-get install -y sysstat
# Verify: which pidstat

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > "$CSV_NAME"

while true; do
    PIDS=$(pgrep -f uvicorn | head -1)
    
    if [ -z "$PIDS" ]; then
        sleep 1
        continue
    fi
    
    # Use pidstat for accurate per-process CPU and memory monitoring
    # -u = CPU stats, -r = memory stats, -p PID = specific process
    # 1 2 = 1 second interval, 2 samples (takes ~1 second total)
    DATA=$(pidstat -u -r -p "$PIDS" 1 2 2>/dev/null | tail -2 | head -1 | awk '
        NF && $1 ~ /[0-9]+:[0-9]+:[0-9]+/ {
            cpu = $8
            printf "%.1f", cpu
        }')
    
    MEM=$(pidstat -u -r -p "$PIDS" 1 2 2>/dev/null | tail -1 | awk '
        NF && $1 ~ /[0-9]+:[0-9]+:[0-9]+/ {
            rss_kb = $7
            mem_mb = rss_kb / 1024
            printf "%.1f", mem_mb
        }')
    
    DATA="$DATA,$MEM"
    
    if [ -z "$DATA" ]; then
        sleep 1
        continue
    fi
    
    TIMESTAMP=$(date +%s)
    echo "$TIMESTAMP,$DATA" >> "$CSV_NAME"
done
