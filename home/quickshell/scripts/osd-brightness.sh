#!/usr/bin/env bash
STEP="${1:-5%+}"

brightnessctl -e4 -n2 set "$STEP" >/dev/null 2>&1

VAL=$(brightnessctl -c backlight -m 2>/dev/null | head -n 1 | cut -d, -f4 | tr -d '%')
if [ -z "$VAL" ]; then
    VAL=$(brightnessctl -m 2>/dev/null | head -n 1 | cut -d, -f4 | tr -d '%')
fi

if [ -n "$VAL" ]; then
    quickshell ipc call osd showBrightness "$VAL" >/dev/null 2>&1 || true
fi
