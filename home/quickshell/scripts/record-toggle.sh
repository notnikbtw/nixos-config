#!/usr/bin/env bash

TARGET_DIR="$HOME/Videos/Recordings"
LOCK_FILE="/tmp/screenrec.lock"
mkdir -p "$TARGET_DIR"

if pgrep -x "wf-recorder" >/dev/null 2>&1 || pgrep -x "wl-screenrec" >/dev/null 2>&1; then
    CURRENT_FILE=""
    if [ -f "$LOCK_FILE" ]; then
        CURRENT_FILE=$(cat "$LOCK_FILE" 2>/dev/null)
    fi

    pkill -INT -x "wf-recorder" 2>/dev/null
    pkill -INT -x "wl-screenrec" 2>/dev/null

    for _ in {1..50}; do
        if ! pgrep -x "wf-recorder" >/dev/null 2>&1 && ! pgrep -x "wl-screenrec" >/dev/null 2>&1; then
            break
        fi
        sleep 0.1
    done

    rm -f "$LOCK_FILE"

    TARGET_FILE="$CURRENT_FILE"

    if [ -n "$TARGET_FILE" ] && [ -f "$TARGET_FILE" ]; then
        FILE_SIZE=$(stat -c%s "$TARGET_FILE" 2>/dev/null || echo 0)
        if [ "$FILE_SIZE" -gt 1024 ]; then
            notify-send -i camera-video "Screen Recording" "Recording saved:\n$(basename "$TARGET_FILE")"
        else
            rm -f "$TARGET_FILE"
            notify-send -u critical -i dialog-error "Screen Recording" "Error: recording is corrupted or empty"
        fi
    elif [ -n "$TARGET_FILE" ]; then
        notify-send -u critical -i dialog-error "Screen Recording" "Error: video file was not created"
    else
        notify-send -i camera-video "Screen Recording" "Recording finished"
    fi
    exit 0
fi

MONITOR="$1"
if [ -z "$MONITOR" ] && command -v hyprctl >/dev/null 2>&1; then
    if command -v jq >/dev/null 2>&1; then
        MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | .name')
    elif command -v python3 >/dev/null 2>&1; then
        MONITOR=$(hyprctl monitors -j 2>/dev/null | python3 -c "import sys, json; data = json.load(sys.stdin); print(next((m['name'] for m in data if m.get('focused')), data[0]['name'] if data else 'DP-1'))" 2>/dev/null)
    fi
fi
if [ -z "$MONITOR" ]; then
    MONITOR="DP-1"
fi

FILENAME="$TARGET_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
echo "$FILENAME" > "$LOCK_FILE"

# On NVIDIA Hyprland systems, wl-screenrec does not support block-linear buffer modifiers,
# making wf-recorder the preferred and most reliable tool.
# Specify -p pixel_format=yuv420p for full compatibility with browsers, Discord, and media players.
if command -v wf-recorder >/dev/null 2>&1; then
    wf-recorder -o "$MONITOR" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >/tmp/wf-recorder.log 2>&1 &
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Screen Recording" "Started recording on $MONITOR (wf-recorder)"
        exit 0
    else
        rm -f "$LOCK_FILE" "$FILENAME"
        ERROR_MSG=$(tail -n 2 /tmp/wf-recorder.log 2>/dev/null)
        notify-send -u critical -i dialog-error "Screen Recording" "wf-recorder error:\n$ERROR_MSG"
        exit 1
    fi
fi

if command -v wl-screenrec >/dev/null 2>&1; then
    wl-screenrec --output "$MONITOR" -f "$FILENAME" < /dev/null >/tmp/wl-screenrec.log 2>&1 &
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Screen Recording" "Started recording on $MONITOR (wl-screenrec)"
        exit 0
    else
        rm -f "$LOCK_FILE" "$FILENAME"
        notify-send -u critical -i dialog-error "Screen Recording" "wl-screenrec error. Check /tmp/wl-screenrec.log"
        exit 1
    fi
fi

rm -f "$LOCK_FILE"
notify-send -u critical -i dialog-error "Screen Recording" "Neither wf-recorder nor wl-screenrec found"
exit 1
