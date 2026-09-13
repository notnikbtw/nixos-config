#!/usr/bin/env bash
# Caps Lock state detector for Quickshell OSD

# Small delay to allow XKB / Hyprland to process the key event
sleep 0.04

state=""

# 1. Query Hyprland devices for capsLock state
if command -v hyprctl >/dev/null 2>&1; then
    json=$(hyprctl devices -j 2>/dev/null || true)
    if [ -n "$json" ]; then
        if echo "$json" | grep -E '"capsLock":\s*true' >/dev/null 2>&1; then
            state="on"
        else
            state="off"
        fi
    fi
fi

# 2. Fallback to sysfs LEDs
if [ -z "$state" ] && [ -d /sys/class/leds ]; then
    for f in /sys/class/leds/*::capslock/brightness; do
        if [ -f "$f" ]; then
            val=$(cat "$f" 2>/dev/null)
            if [ "$val" = "1" ]; then
                state="on"
                break
            elif [ "$val" = "0" ]; then
                state="off"
            fi
        fi
    done
fi

[ -z "$state" ] && state="off"

# Notify Quickshell OSD via IPC
quickshell ipc call osd showCapsLock "$state" >/dev/null 2>&1 || true
