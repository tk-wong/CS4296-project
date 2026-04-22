#!/usr/bin/env bash

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > stats.csv

while true; do
    # Get CPU and RAM for all processes named 'gunicorn'
    DATA=$(ps -C uvicorn -o %cpu,%mem --no-headers | awk '{cpu+=$1; mem+=$2} END {print cpu "," mem}')
    TIMESTAMP=$(date +%s)
    if [ -z "$DATA" ] || [ "$DATA" == ",," ]; then
        continue # Skip if no data is available
    fi
    echo "$TIMESTAMP,$DATA" >> stats.csv
    sleep 1
done
