#!/bin/bash

LOGFILE=~/logs/performance.log
INTERVAL=${1:-5}
DURATION=${2:-3600}

echo "=========================================" | tee -a "$LOGFILE"
echo "Performance monitor — $(date '+%Y-%m-%d %H:%M')" | tee -a "$LOGFILE"
echo "Logging every ${INTERVAL}s for ${DURATION}s" | tee -a "$LOGFILE"
echo "Press Ctrl+C to stop early" | tee -a "$LOGFILE"
echo "=========================================" | tee -a "$LOGFILE"

END=$((SECONDS + DURATION))

while [ $SECONDS -lt $END ]; do
    TIMESTAMP=$(date '+%H:%M:%S')

    GPU_STATS=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,utilization.memory,power.draw,memory.used,memory.total \
        --format=csv,noheader,nounits 2>/dev/null)

    GPU_TEMP=$(echo "$GPU_STATS" | awk -F',' '{print $1}' | tr -d ' ')
    GPU_UTIL=$(echo "$GPU_STATS" | awk -F',' '{print $2}' | tr -d ' ')
    GPU_MEM_UTIL=$(echo "$GPU_STATS" | awk -F',' '{print $3}' | tr -d ' ')
    GPU_POWER=$(echo "$GPU_STATS" | awk -F',' '{print $4}' | tr -d ' ')
    GPU_MEM_USED=$(echo "$GPU_STATS" | awk -F',' '{print $5}' | tr -d ' ')
    GPU_MEM_TOTAL=$(echo "$GPU_STATS" | awk -F',' '{print $6}' | tr -d ' ')

    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | tr -d '%us,')
    RAM_USAGE=$(free -m | awk 'NR==2{printf "%.0f/%.0fMB (%.0f%%)", $3,$2,$3*100/$2}')

    LINE="$TIMESTAMP | GPU: ${GPU_TEMP}C ${GPU_UTIL}% util ${GPU_POWER}W ${GPU_MEM_USED}/${GPU_MEM_TOTAL}MB VRAM | CPU: ${CPU_USAGE}% | RAM: ${RAM_USAGE}"

    echo "$LINE" | tee -a "$LOGFILE"
    sleep "$INTERVAL"
done

echo "=========================================" | tee -a "$LOGFILE"
echo "Session ended — $(date '+%Y-%m-%d %H:%M')" | tee -a "$LOGFILE"
echo "=========================================" | tee -a "$LOGFILE"
