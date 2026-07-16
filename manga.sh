#!/bin/bash

PROGRESS_FILE=~/logs/manga_progress.json

if [ ! -f "$PROGRESS_FILE" ]; then
    echo '{}' > "$PROGRESS_FILE"
fi

ACTION="${1:-check}"
shift 2>/dev/null

case "$ACTION" in
    check)
        python3 ~/scripts/manga_check.py
        ;;
    update)
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: manga update \"Title\" <chapter>"
            exit 1
        fi
        python3 ~/scripts/manga_update.py "$1" "$2"
        ;;
    add)
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: manga add \"Title\" <series_id> [current_chapter]"
            exit 1
        fi
        python3 ~/scripts/manga_add.py "$1" "$2" "${3:-0}"
        ;;
    list)
        python3 ~/scripts/manga_list.py
        ;;
    *)
        echo "Usage: manga [check|update|add|list]"
        echo "  manga check                        — check for new chapters"
        echo "  manga update \"Title\" <chapter>     — update your current chapter"
        echo "  manga add \"Title\" <id> [chapter]   — add a new manga to track"
        echo "  manga list                         — show all tracked manga"
        ;;
esac
