# Get the container ID
CONTAINER_ID=$(docker ps -qf "name=your_container_name")

CSV_NAME="docker-stat.csv"

echo "Timestamp,CPU_Percent,Memory_Usage" > $CSV_NAME

# Loop every 1 second
while true; do
    # Get CPU % and Memory Usage
    STATS=$(docker stats $CONTAINER_ID --no-stream --format "{{.CPUPerc}},{{.MemUsage}}")
    TIMESTAMP=$(date +%s)
    echo "$TIMESTAMP,$STATS" >> $CSV_NAME
    sleep 1
done