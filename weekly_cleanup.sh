#!/bin/bash

LOGFILE=~/logs/weekly_cleanup.log
TEMP="/mnt/c/Users/randa/AppData/Local/Temp"
RECYCLE="/mnt/c/\$Recycle.Bin"

echo "=========================================" >> "$LOGFILE"
echo "Weekly cleanup — $(date '+%Y-%m-%d %H:%M')" >> "$LOGFILE"

BEFORE=$(df /mnt/c --output=avail -h | tail -1 | tr -d ' ')
echo "Disk space before: $BEFORE" >> "$LOGFILE"

echo "Clearing temp files..." >> "$LOGFILE"
find "$TEMP" -mindepth 1 -delete 2>/dev/null
echo "Temp files cleared." >> "$LOGFILE"

echo "Emptying recycle bin..." >> "$LOGFILE"
find "$RECYCLE" -mindepth 1 -delete 2>/dev/null
echo "Recycle bin emptied." >> "$LOGFILE"

AFTER=$(df /mnt/c --output=avail -h | tail -1 | tr -d ' ')
echo "Disk space after: $AFTER" >> "$LOGFILE"
echo "=========================================" >> "$LOGFILE"

echo "Done. Log written to $LOGFILE"
