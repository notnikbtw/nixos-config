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
            notify-send -i camera-video "Запис екрану" "Запис збережено:\n$(basename "$TARGET_FILE")"
        else
            rm -f "$TARGET_FILE"
            notify-send -u critical -i dialog-error "Запис екрану" "Помилка: запис пошкоджений або порожній"
        fi
    elif [ -n "$TARGET_FILE" ]; then
        notify-send -u critical -i dialog-error "Запис екрану" "Помилка: файл відео не створено"
    else
        notify-send -i camera-video "Запис екрану" "Запис завершено"
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

# На системах з NVIDIA Hyprland wl-screenrec не підтримує блоково-лінійні модифікатори буфера,
# тому wf-recorder є пріоритетним та надійним інструментом.
# Вказуємо -p pixel_format=yuv420p для повної сумісності з браузерами, Discord та медіаплеєрами.
if command -v wf-recorder >/dev/null 2>&1; then
    wf-recorder -o "$MONITOR" -p pixel_format=yuv420p -f "$FILENAME" < /dev/null >/tmp/wf-recorder.log 2>&1 &
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Запис екрану" "Почато запис на $MONITOR (wf-recorder)"
        exit 0
    else
        rm -f "$LOCK_FILE" "$FILENAME"
        ERROR_MSG=$(tail -n 2 /tmp/wf-recorder.log 2>/dev/null)
        notify-send -u critical -i dialog-error "Запис екрану" "Помилка wf-recorder:\n$ERROR_MSG"
        exit 1
    fi
fi

if command -v wl-screenrec >/dev/null 2>&1; then
    wl-screenrec --output "$MONITOR" -f "$FILENAME" < /dev/null >/tmp/wl-screenrec.log 2>&1 &
    REC_PID=$!
    disown "$REC_PID" 2>/dev/null
    sleep 0.5
    if kill -0 "$REC_PID" 2>/dev/null; then
        notify-send -i camera-video "Запис екрану" "Почато запис на $MONITOR (wl-screenrec)"
        exit 0
    else
        rm -f "$LOCK_FILE" "$FILENAME"
        notify-send -u critical -i dialog-error "Запис екрану" "Помилка wl-screenrec. Перевірте /tmp/wl-screenrec.log"
        exit 1
    fi
fi

rm -f "$LOCK_FILE"
notify-send -u critical -i dialog-error "Запис екрану" "Не знайдено wf-recorder або wl-screenrec"
exit 1
