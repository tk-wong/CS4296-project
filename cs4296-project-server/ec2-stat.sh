#!/usr/bin/env bash

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > "$CSV_NAME"

while true; do
    PIDS=$(pgrep -f uvicorn | head -1)
    
    if [ -z "$PIDS" ]; then
        sleep 1
        continue
    fi
    
    # Run top with 1-second delay between samples (more accurate than 0.2s)
    # -b = batch mode, -d 1 = 1 second delay, -n 2 = 2 iterations
    # Take the 2nd sample (last line) for most accurate reading
    DATA=$(top -b -d 1 -n 2 -p "$PIDS" | tail -1 | awk '
        NF {
            cpu = $(NF-3)
            mem = $(NF-2)
            gsub(/%/, "", cpu)
            gsub(/%/, "", mem)
            printf "%.1f,%.1f", cpu, mem
        }')
    
    if [ -z "$DATA" ]; then
        sleep 1
        continue
    fi
    
    TIMESTAMP=$(date +%s)
    echo "$TIMESTAMP,$DATA" >> "$CSV_NAME"
done
