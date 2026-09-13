#!/usr/bin/env bash
# Adjust backlight brightness and notify Quickshell OSD

STEP="${1:-5%+}"

# Adjust brightness
brightnessctl -e4 -n2 set "$STEP" >/dev/null 2>&1

# Query current percentage
VAL=$(brightnessctl -c backlight -m 2>/dev/null | head -n 1 | cut -d, -f4 | tr -d '%')
if [ -z "$VAL" ]; then
    VAL=$(brightnessctl -m 2>/dev/null | head -n 1 | cut -d, -f4 | tr -d '%')
fi

# Send IPC notification to Quickshell OSD if running
if [ -n "$VAL" ]; then
    quickshell ipc call osd showBrightness "$VAL" >/dev/null 2>&1 || true
fi
