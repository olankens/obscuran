#!/bin/bash

# shellcheck disable=SC2012,SC2034,SC2129

# Fail fast
set -e

# Locate repo root and icons dir
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ICONS_DIR="$REPO_ROOT/src/new"

# Ensure at least one PNG exists
if ! find "$ICONS_DIR" -type f -iname "*.png" | head -n 1 | grep -q .; then
    echo "❌ No PNG files found under $ICONS_DIR"
    exit 1
fi

# Resize and pad icon
resize_icon() {
    TARGET_SIZE=$1
    FILENAME=$2

    # Padding: 10%
    PAD=$((TARGET_SIZE * 10 / 100))

    # Content size
    CONTENT_SIZE=$((TARGET_SIZE - 2 * PAD))

    # Resize
    sips -z "$CONTENT_SIZE" "$CONTENT_SIZE" "$SRC" \
        --out "$TMP_RESIZED" >/dev/null

    # Pad to target
    sips -s format png \
        --padToHeightWidth "$TARGET_SIZE" "$TARGET_SIZE" "$TMP_RESIZED" \
        --out "$OUT/$FILENAME" >/dev/null
}

# Sizes
SIZES=(
    "16 icon_16x16.png"
    "32 icon_16x16@2x.png"
    "32 icon_32x32.png"
    "64 icon_32x32@2x.png"
    "128 icon_128x128.png"
    "256 icon_128x128@2x.png"
    "256 icon_256x256.png"
    "512 icon_256x256@2x.png"
    "512 icon_512x512.png"
    "1024 icon_512x512@2x.png"
)

# Process each PNG → .icns next to it
while IFS= read -r -d '' SRC; do
    OUT="${SRC%.*}.iconset"
    echo "📦 Creating iconset from: $SRC → $OUT"

    # Recreate iconset
    rm -rf "$OUT"
    mkdir "$OUT"

    # Temp file (macOS mktemp)
    TMP_RESIZED="$(mktemp -t iconresize).png"

    # Render sizes
    for s in "${SIZES[@]}"; do
        read -r SIZE FILENAME <<<"$s"
        resize_icon "$SIZE" "$FILENAME"
    done

    # Build .icns
    iconutil -c icns "$OUT"

    # Remove .iconset
    rm -rf "$OUT"

    # Cleanup temp
    rm -f "$TMP_RESIZED"

    # Done
    echo "✅ Created ${OUT%.iconset}.icns"
done < <(find "$ICONS_DIR" -type f -iname "*.png" -print0)
