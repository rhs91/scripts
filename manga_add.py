import json
import os
import sys

PROGRESS_FILE = os.path.expanduser("~/logs/manga_progress.json")

title = sys.argv[1]
series_id = sys.argv[2]
chapter = sys.argv[3] if len(sys.argv) > 3 else "0"

with open(PROGRESS_FILE) as f:
    progress = json.load(f)

progress[title] = {"chapter": chapter, "series_id": series_id}

with open(PROGRESS_FILE, "w") as f:
    json.dump(progress, f, indent=2)

print(f"Added: {title} (series ID: {series_id}, current chapter: {chapter})")
