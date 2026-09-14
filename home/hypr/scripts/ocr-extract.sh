#!/usr/bin/env bash
set -euo pipefail

SELECTION=$(slurp 2>/dev/null || true)
if [[ -z "$SELECTION" ]]; then
    exit 0
fi

TEXT=$(grim -g "$SELECTION" - 2>/dev/null | tesseract stdin stdout -l eng+ukr 2>/dev/null || grim -g "$SELECTION" - 2>/dev/null | tesseract stdin stdout 2>/dev/null || true)
TEXT=$(printf "%s" "$TEXT" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

if [[ -n "$TEXT" ]]; then
    printf "%s" "$TEXT" | wl-copy
    PREVIEW="${TEXT:0:80}"
    if (( ${#TEXT} > 80 )); then PREVIEW="${PREVIEW}..."; fi
    notify-send -a "OCR Text Extractor" -i edit-copy "Text Copied to Clipboard" "$PREVIEW"
else
    notify-send -a "OCR Text Extractor" -u low "No Text Found" "Could not extract text from selected area"
fi
