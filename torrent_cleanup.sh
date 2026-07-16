#!/bin/bash

MOVIES="/mnt/e/Movies"
TVSHOWS="/mnt/e/TV Shows"
JUNK_EXTENSIONS="nfo txt url jpg jpeg png sfv idx srt"

echo "Scanning for junk files..."

for folder in "$MOVIES" "$TVSHOWS"; do
    echo ""
    echo "--- $folder ---"
    for ext in $JUNK_EXTENSIONS; do
        find "$folder" -iname "*.${ext}" | while read -r file; do
            rm "$file"
            echo "Deleted: $file"
        done
    done
done

echo ""
echo "Done."
