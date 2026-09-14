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

MODE="${1:-fullscreen}"
GEOMETRY=""
MONITOR=""

if [[ "$MODE" == "region" || "$MODE" == "area" ]]; then
    if ! command -v slurp >/dev/null 2>&1; then
        notify-send -u critical -i dialog-error "Screen Recording" "slurp is required for region recording"
        exit 1
    fi
    GEOMETRY=$(slurp 2>/dev/null || true)
    if [[ -z "$GEOMETRY" ]]; then
        exit 0
    fi
else
    if [[ "$MODE" != "fullscreen" && "$MODE" != "" ]]; then
        MONITOR="$MODE"
    fi
    if [ -z "$MONITOR" ] && command -v hyprctl >/dev/null 2>&1; then
        if command -v jq >/dev/null 2>&1; then
            MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | .name')
        fi
    fi
    if [ -z "$MONITOR" ]; then
        MONITOR="DP-1"
    fi
fi

FILENAME="$TARGET_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
echo "$FILENAME" > "$LOCK_FILE"

# Prefer wf-recorder for full NVIDIA buffer modifier support
if command -v wf-recorder >/dev/null 2>&1; then
    if [[ -n "$GEOMETRY" ]]; then
        wf-recorder -g "$GEOMETRY" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >/tmp/wf-recorder.log 2>&1 &
    else
        wf-recorder -o "$MONITOR" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >/tmp/wf-recorder.log 2>&1 &
    fi
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        if [[ -n "$GEOMETRY" ]]; then
            notify-send -i camera-video "Screen Recording" "Started recording selected region"
        else
            notify-send -i camera-video "Screen Recording" "Started recording on $MONITOR"
        fi
        exit 0
    else
        rm -f "$LOCK_FILE" "$FILENAME"
        ERROR_MSG=$(tail -n 2 /tmp/wf-recorder.log 2>/dev/null)
        notify-send -u critical -i dialog-error "Screen Recording" "wf-recorder error:\n$ERROR_MSG"
        exit 1
    fi
fi

if command -v wl-screenrec >/dev/null 2>&1; then
    if [[ -n "$GEOMETRY" ]]; then
        wl-screenrec -g "$GEOMETRY" -f "$FILENAME" < /dev/null >/tmp/wl-screenrec.log 2>&1 &
    else
        wl-screenrec --output "$MONITOR" -f "$FILENAME" < /dev/null >/tmp/wl-screenrec.log 2>&1 &
    fi
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Screen Recording" "Started recording (wl-screenrec)"
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
