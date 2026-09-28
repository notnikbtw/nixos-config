#!/usr/bin/env bash

wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

sleep 0.03

status=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || true)
if echo "$status" | grep -q "\[MUTED\]"; then
    is_muted="muted"
    notify_icon="microphone-disabled"
    notify_text="Microphone Muted"
else
    is_muted="active"
    notify_icon="audio-input-microphone"
    notify_text="Microphone Active"
fi

if ! quickshell ipc call osd showMic "$is_muted" >/dev/null 2>&1; then
    notify-send -h string:x-canonical-private-synchronous:mic-osd -i "$notify_icon" "Microphone" "$notify_text"
fi
