# Get the container ID
CONTAINER_ID="project-server"

CSV_NAME="docker-stat.csv"

if [ "$(id -u)" -eq 0 ]; then
    DOCKER_CMD=(docker)
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "This script needs sudo to run docker stats. Please run it as root or install sudo." >&2
        exit 1
    fi
    DOCKER_CMD=(sudo docker)
fi

echo "Timestamp,CPU_Percent,Memory_Usage" > "$CSV_NAME"

# Loop every 1 second
while true; do
    # Get CPU % and Memory Usage
    STATS=$("${DOCKER_CMD[@]}" stats "$CONTAINER_ID" --no-stream --format "{{.CPUPerc}},{{.MemUsage}}")
    if [ -z "$STATS" ]; then
        sleep 1
        continue # Skip if no data is available
    fi
    TIMESTAMP=$(date +%s)
    echo "$TIMESTAMP,$STATS" >> "$CSV_NAME"
    sleep 1
done