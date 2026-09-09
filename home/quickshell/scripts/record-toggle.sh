#!/usr/bin/env bash

TARGET_DIR="$HOME/Videos/Recordings"
LOCK_FILE="/tmp/screenrec.lock"
mkdir -p "$TARGET_DIR"

if pgrep -x "wl-screenrec" >/dev/null 2>&1 || pgrep -x "wf-recorder" >/dev/null 2>&1; then
    pkill -INT -x "wl-screenrec" 2>/dev/null
    pkill -INT -x "wf-recorder" 2>/dev/null

    for _ in {1..30}; do
        if ! pgrep -x "wl-screenrec" >/dev/null 2>&1 && ! pgrep -x "wf-recorder" >/dev/null 2>&1; then
            break
        fi
        sleep 0.1
    done

    rm -f "$LOCK_FILE"

    LATEST_FILE=$(ls -t "$TARGET_DIR"/*.mp4 2>/dev/null | head -n 1)
    if [ -n "$LATEST_FILE" ]; then
        notify-send -i camera-video "Запис екрану" "Запис завершено:\n$(basename "$LATEST_FILE")"
    else
        notify-send -i camera-video "Запис екрану" "Запис завершено"
    fi
    exit 0
fi

MONITOR="$1"
if [ -z "$MONITOR" ] && command -v hyprctl >/dev/null 2>&1; then
    MONITOR=$(hyprctl monitors -j 2>/dev/null | grep -B 2 '"focused": true' | grep '"name":' | head -n 1 | cut -d'"' -f4)
fi
if [ -z "$MONITOR" ]; then
    MONITOR="DP-1"
fi

FILENAME="$TARGET_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
touch "$LOCK_FILE"

if command -v wl-screenrec >/dev/null 2>&1; then
    wl-screenrec --output "$MONITOR" -f "$FILENAME" >/tmp/wl-screenrec.log 2>&1 &
    REC_PID=$!
    sleep 0.4
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Запис екрану" "Почато запис на $MONITOR (wl-screenrec)"
        exit 0
    fi
fi

if command -v wf-recorder >/dev/null 2>&1; then
    notify-send -i camera-video "Запис екрану" "Почато запис на $MONITOR (wf-recorder)"
    wf-recorder -o "$MONITOR" -f "$FILENAME" >/dev/null 2>&1 &
    exit 0
fi

rm -f "$LOCK_FILE"
notify-send -u critical -i dialog-error "Запис екрану" "Помилка запуску запису екрану. Перевірте /tmp/wl-screenrec.log"
exit 1
