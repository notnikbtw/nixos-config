#!/usr/bin/env bash
set -euo pipefail

COLOR=$(hyprpicker -a -f hex 2>/dev/null || true)
if [[ -n "$COLOR" ]]; then
    printf "%s" "$COLOR" | wl-copy
    notify-send -a "Color Picker" -i color-picker "Color Picked" "$COLOR copied to clipboard"
fi
