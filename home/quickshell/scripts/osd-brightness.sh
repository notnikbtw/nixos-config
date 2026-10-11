#!/usr/bin/env bash
STEP="${1:-5%+}"

VAL=$(brightnessctl -c backlight -e4 -n2 -m set "$STEP" 2>/dev/null | head -n 1 | cut -d, -f4 | tr -d '%')

if [ -n "$VAL" ]; then
    quickshell ipc call osd showBrightness "$VAL" >/dev/null 2>&1 || true
fi
