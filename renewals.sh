#!/bin/bash

python3 << 'EOF'
import csv
import os
from datetime import datetime, date

today = date.today()
csvdir = "/mnt/d/WORK"

buckets = {"30": [], "60": [], "90": []}
seen = set()

for i in [3, 4]:
    filepath = os.path.join(csvdir, f"sheet{i}.csv")
    with open(filepath, encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            customer = row.get("End User", "").strip()
            renew_str = row.get("Auto Renew Date", "").strip()
            arr = row.get("Sum of ARR", "").strip()
            status = row.get("Status", "").strip()

            if not renew_str or not customer:
                continue
            if any(status.lower().startswith(s) for s in ["done", "churn"]):
                continue

            try:
                renew_date = datetime.strptime(renew_str, "%m/%d/%Y").date()
            except ValueError:
                continue

            days_until = (renew_date - today).days

            if days_until < 0:
                continue

            key = (customer, renew_str)
            if key in seen:
                continue
            seen.add(key)

            if days_until <= 30:
                buckets["30"].append((days_until, customer, renew_str, arr))
            elif days_until <= 60:
                buckets["60"].append((days_until, customer, renew_str, arr))
            elif days_until <= 90:
                buckets["90"].append((days_until, customer, renew_str, arr))

print("=========================================")
print(f" Renewal Tracker — {today.strftime('%B %d, %Y')}")
print("=========================================")

for label, key in [("30 days", "30"), ("31-60 days", "60"), ("61-90 days", "90")]:
    print(f"\n--- Renewing within {label} ---")
    if not buckets[key]:
        print("  None")
    else:
        for days, customer, renew_date, arr in sorted(buckets[key]):
            print(f"  {customer:<40} {renew_date:<15} {arr:<15} ({days}d)")

print("\n=========================================")
EOF
