#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./healthlog.sh <customer name>"
    echo "       ./healthlog.sh <customer name> --history"
    exit 1
fi

CUSTOMER="$1"
LOGFILE=~/logs/health.log

if [ "$2" = "--history" ]; then
    echo "--- History for $CUSTOMER ---"
    grep -i "$CUSTOMER" "$LOGFILE" 2>/dev/null || echo "No entries found."
    exit 0
fi

read -p "Note: " NOTE
echo "$(date '+%Y-%m-%d %H:%M') | $CUSTOMER | $NOTE" >> "$LOGFILE"
echo "Logged."
