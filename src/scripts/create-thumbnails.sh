#!/bin/bash

# shellcheck disable=SC2012,SC2034,SC2129

# Fail fast
set -e

# Locate repo root and icons dir
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ICONS_DIR="$REPO_ROOT/src/icons"
ASSETS_DIR="$REPO_ROOT/.assets"

# Ensure assets directory exists
mkdir -p "$ASSETS_DIR"

# Check for ImageMagick (required for whitespace removal)
if ! command -v convert >/dev/null 2>&1; then
    echo "Warning: ImageMagick not found. Whitespace removal will be skipped."
    echo "Install with: brew install imagemagick"
fi

# Ensure at least one ICNS exists
if ! find "$ICONS_DIR" -type f -iname "*.icns" | head -n 1 | grep -q .; then
    echo "Error: No ICNS files found under $ICONS_DIR"
    exit 1
fi

# Thumbnail size
THUMBNAIL_SIZE=256

# Process each ICNS → PNG thumbnail
while IFS= read -r -d '' ICNS_FILE; do
    # Get filename without extension
    BASENAME=$(basename "$ICNS_FILE" .icns)
    OUTPUT_PNG="$ASSETS_DIR/${BASENAME}.png"

    echo "Creating thumbnail from: $ICNS_FILE → $OUTPUT_PNG"

    # Extract largest representation from ICNS and resize to thumbnail
    sips -s format png -z "$THUMBNAIL_SIZE" "$THUMBNAIL_SIZE" "$ICNS_FILE" \
        --out "$OUTPUT_PNG" >/dev/null

    # Remove whitespace/transparent areas using ImageMagick convert with trim
    if command -v convert >/dev/null 2>&1; then
        convert "$OUTPUT_PNG" -trim +repage "$OUTPUT_PNG" 2>/dev/null || {
            echo "Warning: ImageMagick trim failed, keeping original size"
        }
    else
        echo "Warning: ImageMagick not found, whitespace removal skipped"
    fi

    # Optimize PNG (reduce file size while maintaining quality)
    sips -s format png -s formatOptions normal "$OUTPUT_PNG" \
        --out "$OUTPUT_PNG" >/dev/null

    echo "Created thumbnail: $OUTPUT_PNG"

done < <(find "$ICONS_DIR" -maxdepth 2 -type f -iname "*.icns" -print0)

echo "All thumbnails created successfully in $ASSETS_DIR"
