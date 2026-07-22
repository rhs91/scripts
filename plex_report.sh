#!/bin/bash

MOVIES="/mnt/e/Movies"
TVSHOWS="/mnt/e/TV Shows"

echo "========================================="
echo " Plex Library Report — $(date '+%Y-%m-%d')"
echo "========================================="

echo ""
echo "--- Movies with naming issues ---"
find "$MOVIES" -maxdepth 1 | tail -n +2 | while read -r item; do
    name=$(basename "$item")
    if [[ ! "$name" =~ ^.+\ \([0-9]{4}\)$ ]]; then
        echo "  $name"
    fi
done

echo ""
echo "--- TV episodes with naming issues ---"
find "$TVSHOWS" -maxdepth 2 -type f \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" \) | while read -r file; do
    name=$(basename "$file")
    if [[ ! "$name" =~ S[0-9]{2}E[0-9]{2} ]]; then
        echo "  $name"
    fi
done

echo ""
echo "--- Recently added movies (last 30 days) ---"
find "$MOVIES" -maxdepth 1 -mtime -30 | tail -n +2 | while read -r item; do
    name=$(basename "$item")
    echo "  $name"
done

echo ""
echo "========================================="
