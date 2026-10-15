#!/usr/bin/env bash

case "$1" in
    caps) led="capslock"; key="capsLock"; method="showCapsLock" ;;
    num)  led="numlock";  key="numLock";  method="showNumLock" ;;
    *) echo "usage: $0 caps|num" >&2; exit 1 ;;
esac

state=""

if compgen -G "/sys/class/leds/*${led}*/brightness" >/dev/null 2>&1; then
    if grep -q 1 /sys/class/leds/*${led}*/brightness 2>/dev/null; then
        state="on"
    else
        state="off"
    fi
fi

if [ -z "$state" ] && command -v hyprctl >/dev/null 2>&1; then
    json=$(hyprctl devices -j 2>/dev/null || true)
    if [ -n "$json" ]; then
        if echo "$json" | grep -E "\"${key}\":\s*true" >/dev/null 2>&1; then
            state="on"
        else
            state="off"
        fi
    fi
fi

[ -z "$state" ] && state="off"

quickshell ipc call osd "$method" "$state" >/dev/null 2>&1 || true
