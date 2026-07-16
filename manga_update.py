import json
import os
import sys

PROGRESS_FILE = os.path.expanduser("~/logs/manga_progress.json")

title = sys.argv[1]
chapter = sys.argv[2]

with open(PROGRESS_FILE) as f:
    progress = json.load(f)

progress[title] = {"chapter": chapter}

with open(PROGRESS_FILE, "w") as f:
    json.dump(progress, f, indent=2)

print(f"Updated: {title} → ch.{chapter}")
