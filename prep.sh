#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: prep.sh <customer name>"
    exit 1
fi

CUSTOMER="$1"
LOGFILE=~/logs/health.log
CSVDIR="/mnt/d/WORK"

echo "========================================="
echo " Call Prep: $CUSTOMER"
echo " $(date '+%Y-%m-%d %H:%M')"
echo "========================================="

echo ""
echo "--- Renewal Status ---"
python3 << PYEOF
import csv
import os
from datetime import datetime, date

today = date.today()
customer = "$CUSTOMER".lower()
found = False
seen = set()

for i in [3, 4]:
    filepath = os.path.join("$CSVDIR", f"sheet{i}.csv")
    try:
        with open(filepath, encoding="utf-8-sig") as f:
            reader = csv.DictReader(f)
            for row in reader:
                name = row.get("End User", "").strip()
                if customer in name.lower():
                    renew_str = row.get("Auto Renew Date", "").strip()
                    arr = row.get("Sum of ARR", "").strip()
                    status = row.get("Status", "").strip()
                    try:
                        if name in seen:
                            continue
                        seen.add(name)
                        renew_date = datetime.strptime(renew_str, "%m/%d/%Y").date()
                        days = (renew_date - today).days
                        direction = f"in {days} days" if days >= 0 else f"{abs(days)} days ago"
                        print(f"  Customer : {name}")
                        print(f"  ARR      : {arr}")
                        print(f"  Renewal  : {renew_str} ({direction})")
                        print(f"  Status   : {status if status else 'Not set'}")
                        found = True
                    except:
                        pass
    except FileNotFoundError:
        pass

if not found:
    print("  No renewal data found.")
PYEOF

echo ""
echo "--- Health Log History ---"
if [ -f "$LOGFILE" ]; then
    RESULTS=$(grep -i "$CUSTOMER" "$LOGFILE")
    if [ -n "$RESULTS" ]; then
        echo "$RESULTS"
    else
        echo "  No entries found."
    fi
else
    echo "  No health log found."
fi

echo ""
echo "========================================="
