#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REFERENCES_DIR="$SCRIPT_DIR/../references"

# TODO: Copy Finder, Safari, Terminal, Google Chorme, Chromium ICNS to refrences directory
cp "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" "$REFERENCES_DIR/finder.icns"
cp "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/Contents/Resources/AppIcons.icns" "$REFERENCES_DIR/safari.icns"
cp "/System/Applications/Utilities/Terminal.app/Contents/Resources/Terminal.icns" "$REFERENCES_DIR/terminal.icns"
cp "/Applications/Chromium.app/Contents/Resources/app.icns" "$REFERENCES_DIR/chromium.icns"
cp "/Applications/Google Chrome.app/Contents/Resources/app.icns" "$REFERENCES_DIR/chrome.icns"

# TODO: Convert Finder, Safari, Terminal, Google Chorme, Chromium ICNS to refrences directory
sips -s format png "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" --out "$REFERENCES_DIR/finder.png"
sips -s format png "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/Contents/Resources/AppIcons.icns" --out "$REFERENCES_DIR/safari.png"
sips -s format png "/System/Applications/Utilities/Terminal.app/Contents/Resources/Terminal.icns" --out "$REFERENCES_DIR/terminal.png"
sips -s format png "/Applications/Chromium.app/Contents/Resources/app.icns" --out "$REFERENCES_DIR/chromium.png"
sips -s format png "/Applications/Google Chrome.app/Contents/Resources/app.icns" --out "$REFERENCES_DIR/chrome.png"
