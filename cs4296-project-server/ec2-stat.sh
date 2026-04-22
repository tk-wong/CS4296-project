#!/usr/bin/env bash

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > "$CSV_NAME"

while true; do
    PIDS=$(pgrep -d, uvicorn)
    
    if [ -z "$PIDS" ]; then
        sleep 1
        continue
    fi
    
    DATA=$(top -b -n 2 -d 0.2 -p "$PIDS" | tail -1 | awk '
        NF {
            cpu = $(NF-3)
            mem = $(NF-2)
            gsub(/%/, "", cpu)
            gsub(/%/, "", mem)
            print cpu "," mem
        }')
    
    TIMESTAMP=$(date +%s)

    if [ -z "$DATA" ]; then
        sleep 1
        continue
    fi

    echo "$TIMESTAMP,$DATA" >> "$CSV_NAME"
    sleep 1
done
