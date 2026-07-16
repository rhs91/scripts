#!/bin/bash

TVDIR="/mnt/e/TV Shows"
DRY_RUN=true

[ "$1" = "--go" ] && DRY_RUN=false

echo "TV rename — $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo ""

for show in "$TVDIR"/*/; do
    show_name=$(basename "$show")
    changed=false

    for item in "$show"*; do
        [ -e "$item" ] || continue
        name=$(basename "$item")
        ext="${name##*.}"
        clean="$name"

        # Skip already clean SxxExx format
        if [[ "$name" =~ ^.+S[0-9]{2}E[0-9]{2}.*$ ]] && [[ ! "$name" =~ ^www\. ]] && [[ ! "$name" =~ \[TGx\] ]] && [[ ! "$name" =~ \[eztv ]]; then
            continue
        fi

        # Strip www site prefixes
        clean=$(echo "$clean" | sed 's/^\[*www\.[^-]*\][[:space:]]*-[^-]*-[[:space:]]*//' | sed 's/^www\.[^-]*-[^-]*-[[:space:]]*//')

        # Replace dots with spaces (but not in file extension)
        if [[ "$name" == *.mkv ]] || [[ "$name" == *.mp4 ]] || [[ "$name" == *.avi ]]; then
            base="${clean%.*}"
            base=$(echo "$base" | sed 's/\./ /g')
            clean="${base}.${ext}"
        else
            clean=$(echo "$clean" | sed 's/\./ /g')
        fi

        # Extract Show SxxExx and strip everything after
        if [[ "$clean" =~ (.*)(S[0-9]{2}E[0-9]{2}).* ]]; then
            title="${BASH_REMATCH[1]}"
            episode="${BASH_REMATCH[2]}"
            # Clean up trailing spaces and dashes from title
            title=$(echo "$title" | sed 's/[[:space:]]*[-]*[[:space:]]*$//')
            if [[ "$name" == *.mkv ]] || [[ "$name" == *.mp4 ]] || [[ "$name" == *.avi ]]; then
                clean="${title} ${episode}.${ext}"
            else
                clean="${title} ${episode}"
            fi
        else
            continue
        fi

        # Skip if nothing changed
        [ "$name" = "$clean" ] && continue

        if [ "$changed" = false ]; then
            echo "[$show_name]"
            changed=true
        fi

        echo "  $name"
        echo "→ $clean"
        echo ""

        if [ "$DRY_RUN" = false ]; then
            mv "$show/$name" "$show/$clean"
        fi
    done
done

[ "$DRY_RUN" = true ] && echo "Run with --go to apply changes."
