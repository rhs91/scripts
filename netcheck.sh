#!/bin/bash

LOGFILE=~/logs/netcheck.log
SITES=(
    "google.com"
    "github.com"
    "reddit.com"
    "thepiratebay.bond"
    "8.8.8.8"
)

echo "=========================================" >> "$LOGFILE"
echo "Network check — $(date '+%Y-%m-%d %H:%M')" >> "$LOGFILE"
echo ""

UP=0
DOWN=0

for site in "${SITES[@]}"; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" --max-time 10 "https://$site" 2>/dev/null)
    CODE=$(echo "$RESPONSE" | cut -d' ' -f1)
    TIME=$(echo "$RESPONSE" | cut -d' ' -f2)

    if [ "$CODE" -ge 200 ] && [ "$CODE" -lt 400 ] 2>/dev/null; then
        echo "  UP   $site (${TIME}s)" | tee -a "$LOGFILE"
        ((UP++))
    else
        echo "  DOWN $site (code: $CODE)" | tee -a "$LOGFILE"
        ((DOWN++))
    fi
done

echo "" 
echo "  $UP up, $DOWN down" | tee -a "$LOGFILE"
echo "=========================================" >> "$LOGFILE"
