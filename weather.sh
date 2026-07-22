#!/bin/bash

LOCATION="Eugene,OR"

echo "========================================="
echo " Weather — $LOCATION"
echo " $(date '+%Y-%m-%d %H:%M')"
echo "========================================="
echo ""

curl -s "wttr.in/${LOCATION}?T"

echo "========================================="
