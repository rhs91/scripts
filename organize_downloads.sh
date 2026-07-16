#!/bin/bash

DOWNLOADS="/mnt/c/Users/randa/Downloads"

echo "Organizing Downloads folder..."

declare -A folders
folders=(
    ["books"]="epub mobi azw azw3"
    ["pdfs"]="pdf"
    ["images"]="jpg jpeg png gif webp bmp tiff"
    ["videos"]="mp4 mkv avi mov wmv m4v"
    ["zips"]="zip rar 7z tar gz"
    ["music"]="mp3 flac wav aac ogg"
    ["torrents"]="torrent"
)

for category in "${!folders[@]}"; do
    mkdir -p "$DOWNLOADS/$category"
done

for file in "$DOWNLOADS"/*; do
    [ -f "$file" ] || continue
    ext="${file##*.}"
    ext="${ext,,}"

    if [ "$ext" = "torrent" ]; then
        rm "$file"
        echo "Deleted: $(basename "$file")"
        continue
    fi

    for category in "${!folders[@]}"; do
        if echo "${folders[$category]}" | grep -qw "$ext"; then
            mv "$file" "$DOWNLOADS/$category/"
            echo "Moved: $(basename "$file") → $category"
            break
        fi
    done
done

echo ""
echo "Done."
