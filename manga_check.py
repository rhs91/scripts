import urllib.request
import json
from datetime import datetime, date
import os

PROGRESS_FILE = os.path.expanduser("~/logs/manga_progress.json")

MANGA_LIST = [
    {"title": "Berserk", "id": 51239621230},
    {"title": "The Guy She Was Interested In Wasn't a Guy At All", "id": 28792959847},
    {"title": "SPY x Family", "id": 67814124606},
    {"title": "Bocchi the Rock!", "id": 31629433150},
]

with open(PROGRESS_FILE) as f:
    progress = json.load(f)

print("=========================================")
print(f" Manga Tracker — {date.today().strftime('%B %d, %Y')}")
print("=========================================")
print()

for manga in MANGA_LIST:
    title = manga["title"]
    manga_id = manga["id"]
    current_ch = float(progress.get(title, {}).get("chapter", 0))

    url = "https://api.mangaupdates.com/v1/releases/search"
    payload = json.dumps({"series_id": manga_id, "per_page": 15}).encode()
    req = urllib.request.Request(
        url, data=payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read())
            results = data.get("results", [])

            new_chapters = []
            seen_chapters = set()

            for r in results:
                record = r["record"]
                record_series_id = record.get("series", {}).get("series_id")
                if record_series_id != manga_id:
                    continue
                try:
                    ch_num = float(record.get("chapter", 0))
                except:
                    continue
                if ch_num > current_ch and ch_num not in seen_chapters:
                    seen_chapters.add(ch_num)
                    release_date = datetime.strptime(record["release_date"], "%Y-%m-%d").date()
                    groups = ", ".join(g["name"] for g in record.get("groups", []))
                    new_chapters.append((ch_num, release_date, groups))

            new_chapters.sort()
            ch_display = int(current_ch) if current_ch == int(current_ch) else current_ch

            if new_chapters:
                print(f"--- {title} --- (you're on ch.{ch_display})")
                for ch, rel_date, groups in new_chapters:
                    ch_out = int(ch) if ch == int(ch) else ch
                    age = (date.today() - rel_date).days
                    print(f"  Ch.{ch_out} — {rel_date} ({age} days ago) [{groups}]")
                print()
            else:
                print(f"--- {title} --- up to date (ch.{ch_display})")
                print()

    except Exception as e:
        print(f"  Error fetching {title}: {e}")
        print()

print("=========================================")
