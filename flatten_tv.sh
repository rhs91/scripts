#!/bin/bash

TVDIR="/mnt/e/TV Shows"
DRY_RUN=true

[ "$1" = "--go" ] && DRY_RUN=false

echo "TV flatten — $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo ""

for show in "$TVDIR"/*/; do
    show_name=$(basename "$show")
    changed=false

    for subfolder in "$show"*/; do
        [ -d "$subfolder" ] || continue

        for mkv in "$subfolder"*.mkv "$subfolder"*.mp4 "$subfolder"*.avi; do
            [ -f "$mkv" ] || continue
            filename=$(basename "$mkv")
            dest="$show/$filename"

            if [ -f "$dest" ]; then
                echo "  SKIP (exists): $filename"
                continue
            fi

            if [ "$changed" = false ]; then
                echo "[$show_name]"
                changed=true
            fi

            echo "  $(basename "$subfolder")/$filename"
            echo "→ $show_name/$filename"
            echo ""

            if [ "$DRY_RUN" = false ]; then
                mv "$mkv" "$dest"
            fi
        done
    done
done

[ "$DRY_RUN" = true ] && echo "Run with --go to apply changes."
