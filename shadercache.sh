#!/bin/bash

LOGFILE=~/logs/shadercache.log
DXCACHE="/mnt/c/Users/randa/AppData/Local/NVIDIA/DXCache"
GLCACHE="/mnt/c/Users/randa/AppData/Local/NVIDIA/GLCache"
D3DSCACHE="/mnt/c/Users/randa/AppData/Local/D3DSCache"

echo "=========================================" >> "$LOGFILE"
echo "Shader cache clean — $(date '+%Y-%m-%d %H:%M')" >> "$LOGFILE"

for cache in "$DXCACHE" "$GLCACHE" "$D3DSCACHE"; do
    BEFORE=$(du -sh "$cache" 2>/dev/null | cut -f1)
    find "$cache" -mindepth 1 -delete 2>/dev/null
    echo "Cleared $cache ($BEFORE freed)" >> "$LOGFILE"
done

echo "=========================================" >> "$LOGFILE"
echo "Done. Log written to $LOGFILE"
