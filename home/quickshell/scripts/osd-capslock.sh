#!/usr/bin/env bash

state=""

if compgen -G "/sys/class/leds/*capslock*/brightness" >/dev/null 2>&1; then
    if grep -q 1 /sys/class/leds/*capslock*/brightness 2>/dev/null; then
        state="on"
    else
        state="off"
    fi
fi

if [ -z "$state" ] && command -v hyprctl >/dev/null 2>&1; then
    json=$(hyprctl devices -j 2>/dev/null || true)
    if [ -n "$json" ]; then
        if echo "$json" | grep -E '"capsLock":\s*true' >/dev/null 2>&1; then
            state="on"
        else
            state="off"
        fi
    fi
fi

[ -z "$state" ] && state="off"

quickshell ipc call osd showCapsLock "$state" >/dev/null 2>&1 || true
