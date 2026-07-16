#!/bin/bash

TOP=${2:-10}

if [ -n "$1" ] && [ "$1" != "-" ]; then
    if [ ! -f "$1" ]; then
        echo "File not found: $1"
        exit 1
    fi
    echo "Top $TOP words in $(basename $1):"
    echo ""
    cat "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -cs '[:alpha:]' '\n' \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -n "$TOP"
else
    echo "Top $TOP words:"
    echo ""
    cat \
        | tr '[:upper:]' '[:lower:]' \
        | tr -cs '[:alpha:]' '\n' \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -n "$TOP"
fi
