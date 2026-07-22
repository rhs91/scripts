import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
import json
import os
from email.utils import parsedate_to_datetime

STATE_FILE = os.path.expanduser("~/logs/rss_state.json")

FEEDS = [
    {"name": "Ars Technica", "url": "https://feeds.arstechnica.com/arstechnica/index"},
    {"name": "Phoronix", "url": "https://www.phoronix.com/rss.php"},
    {"name": "Linux Journal", "url": "https://www.linuxjournal.com/node/feed"},
    {"name": "Rock Paper Shotgun", "url": "https://www.rockpapershotgun.com/feed"},
    {"name": "PC Gamer", "url": "https://www.pcgamer.com/rss/"},
    {"name": "Consequence", "url": "https://consequence.net/feed/"},
]

if os.path.exists(STATE_FILE):
    with open(STATE_FILE) as f:
        state = json.load(f)
else:
    state = {}

now = datetime.now(timezone.utc)
last_checked = datetime.fromisoformat(state.get("last_checked", "2000-01-01T00:00:00+00:00"))

print("=========================================")
print(f" RSS Reader — {now.strftime('%B %d, %Y %H:%M')}")
print(f" Showing articles since {last_checked.strftime('%B %d %H:%M')}")
print("=========================================")
print()

for feed in FEEDS:
    try:
        req = urllib.request.Request(
            feed["url"],
            headers={"User-Agent": "Mozilla/5.0"}
        )
        with urllib.request.urlopen(req, timeout=10) as response:
            tree = ET.parse(response)
            root = tree.getroot()

            items = root.findall(".//item")
            new_items = []

            for item in items:
                pub_date = item.findtext("pubDate")
                title = item.findtext("title")
                link = item.findtext("link")

                if not pub_date or not title:
                    continue

                try:
                    pub_dt = parsedate_to_datetime(pub_date)
                    if pub_dt > last_checked:
                        new_items.append((pub_dt, title.strip(), link))
                except:
                    continue

            new_items.sort(reverse=True)

            if new_items:
                print(f"--- {feed['name']} ({len(new_items)} new) ---")
                for pub_dt, title, link in new_items[:5]:
                    print(f"  {pub_dt.strftime('%m/%d %H:%M')} {title}")
                if len(new_items) > 5:
                    print(f"  ... and {len(new_items) - 5} more")
                print()

    except Exception as e:
        print(f"--- {feed['name']} --- Error: {e}")
        print()

state["last_checked"] = now.isoformat()
with open(STATE_FILE, "w") as f:
    json.dump(state, f, indent=2)

print("=========================================")
