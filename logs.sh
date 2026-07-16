#!/bin/bash

LINES=${1:-20}

echo "========================================="
echo " Log Viewer — $(date '+%Y-%m-%d %H:%M')"
echo "========================================="

for log in ~/logs/*.log; do
    echo ""
    echo "--- $(basename $log) ---"
    tail -n "$LINES" "$log"
done

echo ""
echo "========================================="
