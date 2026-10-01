#!/usr/bin/env bash

TARGET_DIR="$HOME/Videos/Recordings"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/screenrec.lock"
LOG_FILE="${XDG_RUNTIME_DIR:-/tmp}/screenrec.log"
mkdir -p "$TARGET_DIR"

is_recorder_alive() {
    local pid="$1"
    local expected="$2"
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        local comm exe
        comm=$(ps -p "$pid" -o comm= 2>/dev/null)
        exe=$(basename "$(readlink -f "/proc/$pid/exe" 2>/dev/null)" 2>/dev/null)

        for name in "$comm" "$exe"; do
            if [[ -n "$expected" && "$name" == *"$expected"* ]]; then
                return 0
            fi
            if [[ "$name" =~ ^\.?(wf-recorder)(-wrapped)?$ ]]; then
                return 0
            fi
        done
    fi
    return 1
}

if [[ "$1" == "status" ]]; then
    if [ -f "$LOCK_FILE" ]; then
        read -r REC_PID START_TIME REC_COMM TARGET_FILE < "$LOCK_FILE"
        if is_recorder_alive "$REC_PID" "$REC_COMM"; then
            echo "running ${START_TIME:-$(date +%s)}"
            exit 0
        fi
        rm -f "$LOCK_FILE"
    fi
    echo "stopped"
    exit 0
fi

is_recording_active() {
    if [ -f "$LOCK_FILE" ]; then
        local pid start comm file
        read -r pid start comm file < "$LOCK_FILE"
        if is_recorder_alive "$pid" "$comm"; then
            return 0
        fi
        rm -f "$LOCK_FILE"
    fi
    return 1
}

if is_recording_active; then
    REC_PID=""
    START_TIME=""
    REC_COMM=""
    TARGET_FILE=""
    if [ -f "$LOCK_FILE" ]; then
        read -r REC_PID START_TIME REC_COMM TARGET_FILE < "$LOCK_FILE"
    fi

    if [ -n "$REC_PID" ] && is_recorder_alive "$REC_PID" "$REC_COMM"; then
        kill -INT "$REC_PID" 2>/dev/null
        for _ in {1..100}; do
            if ! kill -0 "$REC_PID" 2>/dev/null; then
                break
            fi
            sleep 0.1
        done

        if kill -0 "$REC_PID" 2>/dev/null; then
            kill -KILL "$REC_PID" 2>/dev/null
        fi
    fi

    rm -f "$LOCK_FILE"

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
elif pgrep -x "wf-recorder" >/dev/null 2>&1; then
    pkill -INT -x "wf-recorder" 2>/dev/null
    for _ in {1..30}; do
        if ! pgrep -x "wf-recorder" >/dev/null 2>&1; then
            break
        fi
        sleep 0.1
    done
    rm -f "$LOCK_FILE"
    notify-send -i camera-video "Screen Recording" "Stopped stray recording process"
    exit 0
fi

MODE="${1:-fullscreen}"
GEOMETRY=""
MONITOR=""

if ! command -v wf-recorder >/dev/null 2>&1; then
    notify-send -u critical -i dialog-error "Screen Recording" "wf-recorder is not found in PATH"
    exit 1
fi

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
            MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '(.[] | select(.focused) | .name) // (.[0] | .name) // empty')
        fi
    fi
    if [ -z "$MONITOR" ]; then
        notify-send -u critical -i dialog-error "Screen Recording" "Could not determine focused monitor"
        exit 1
    fi
fi

FILENAME="$TARGET_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
START_TIME=$(date +%s)

if [[ -n "$GEOMETRY" ]]; then
    nohup wf-recorder -g "$GEOMETRY" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >"$LOG_FILE" 2>&1 &
else
    nohup wf-recorder -o "$MONITOR" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >"$LOG_FILE" 2>&1 &
fi
REC_PID=$!
disown "$REC_PID" 2>/dev/null
sleep 0.5

if kill -0 "$REC_PID" 2>/dev/null; then
    echo "$REC_PID $START_TIME wf-recorder $FILENAME" > "$LOCK_FILE"
    if [[ -n "$GEOMETRY" ]]; then
        notify-send -i camera-video "Screen Recording" "Started recording selected region"
    else
        notify-send -i camera-video "Screen Recording" "Started recording on $MONITOR"
    fi
    exit 0
else
    rm -f "$FILENAME"
    ERROR_MSG=$(tail -n 2 "$LOG_FILE" 2>/dev/null)
    notify-send -u critical -i dialog-error "Screen Recording" "wf-recorder error:\n$ERROR_MSG"
    exit 1
fi
