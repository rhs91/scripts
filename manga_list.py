import json
import os

PROGRESS_FILE = os.path.expanduser("~/logs/manga_progress.json")

with open(PROGRESS_FILE) as f:
    progress = json.load(f)

if not progress:
    print("No manga tracked yet.")
else:
    print("Currently tracking:")
    for title, data in progress.items():
        ch = data.get("chapter", 0)
        print(f"  {title} — ch.{ch}")
