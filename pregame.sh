#!/bin/bash

echo "Closing background processes..."

taskkill.exe /F /IM Dropbox.exe /T 2>/dev/null && echo "Dropbox closed" || echo "Dropbox not running"
taskkill.exe /F /IM SearchIndexer.exe /T 2>/dev/null && echo "SearchIndexer closed" || echo "SearchIndexer not running"
taskkill.exe /F /IM OfficeClickToRun.exe /T 2>/dev/null && echo "OfficeClickToRun closed" || echo "OfficeClickToRun not running"

echo ""
echo "Done. Good luck."
