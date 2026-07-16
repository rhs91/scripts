#!/bin/bash

MOVIEDIR="/mnt/e/Movies"
DRY_RUN=true

[ "$1" = "--go" ] && DRY_RUN=false

echo "Movie rename — $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo ""

for item in "$MOVIEDIR"/*/; do
    name=$(basename "$item")
    
    # Already clean - skip
    if [[ "$name" =~ ^.+\ \([0-9]{4}\)$ ]]; then
        continue
    fi

    # Strip www. site prefixes
    clean=$(echo "$name" | sed 's/^www\.[^-]*-[^-]*- *//')

    # Replace dots with spaces
    clean=$(echo "$clean" | sed 's/\./ /g')

    # Strip EXTENDED, REMASTERED, UNRATED, DIRECTORS CUT tags
    clean=$(echo "$clean" | sed 's/ EXTENDED//gi' | sed 's/ REMASTERED//gi' | sed 's/ UNRATED//gi' | sed 's/ DIRECTORS CUT//gi' | sed "s/ DIRECTOR'S CUT//gi")

    # Fix "Se7en ( 1995 )" style spacing around year
    clean=$(echo "$clean" | sed 's/( *\([0-9]\{4\}\) *)/(\1)/g')

    # Extract title and year
    if [[ "$clean" =~ ^(.+)[[:space:]]([0-9]{4})[[:space:]].*$ ]]; then
        title="${BASH_REMATCH[1]}"
        year="${BASH_REMATCH[2]}"
        new_name="${title} (${year})"
    elif [[ "$name" =~ ^(.+)[[:space:]]\(([0-9]{4})\) ]]; then
        title="${BASH_REMATCH[1]}"
        year="${BASH_REMATCH[2]}"
        new_name="${title} (${year})"
    else
        continue
    fi

    if [ "$name" != "$new_name" ]; then
        echo "  $name"
        echo "→ $new_name"
        echo ""
        if [ "$DRY_RUN" = false ]; then
            mv "$MOVIEDIR/$name" "$MOVIEDIR/$new_name"
        fi
    fi
done

[ "$DRY_RUN" = true ] && echo "Run with --go to apply changes."
