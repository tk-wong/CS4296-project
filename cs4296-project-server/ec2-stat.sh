#!/usr/bin/env bash

CSV_NAME="ec2-stat.csv"

echo "Timestamp,CPU_Percent,Memory_MB" > "$CSV_NAME"

while true; do
    DATA=$(ps -C uvicorn -o %cpu,%mem --no-headers | awk '
        NF {
            cpu += $1
            mem += $2
            found = 1
        }
        END {
            if (found) print cpu "," mem
        }')
    TIMESTAMP=$(date +%s)

    if [ -z "$DATA" ]; then
        sleep 1
        continue
    fi

    echo "$TIMESTAMP,$DATA" >> "$CSV_NAME"
    sleep 1
done
