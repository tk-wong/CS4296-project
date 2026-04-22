#!/usr/bin/env bash

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > "$CSV_NAME"

while true; do
    PIDS=$(pgrep -d, uvicorn)
    
    if [ -z "$PIDS" ]; then
        sleep 1
        continue
    fi
    
    DATA=$(top -bn1 -p "$PIDS" | awk '
        NF && NR > 7 {
            cpu = $(NF-2)
            mem = $(NF-1)
            gsub(/%/, "", cpu)
            gsub(/%/, "", mem)
            total_cpu += cpu
            total_mem += mem
            found = 1
        }
        END {
            if (found) print total_cpu "," total_mem
        }')
    
    TIMESTAMP=$(date +%s)

    if [ -z "$DATA" ]; then
        sleep 1
        continue
    fi

    echo "$TIMESTAMP,$DATA" >> "$CSV_NAME"
    sleep 1
done
