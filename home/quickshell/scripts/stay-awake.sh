#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$RUNTIME_DIR/quickshell-stay-awake.pid"
COOKIE_FILE="$RUNTIME_DIR/quickshell-stay-awake.cookie"

is_active() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE" 2>/dev/null || true)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

start() {
    if is_active; then
        exit 0
    fi

    # 1. systemd-inhibit to block sleep, idle, and lid switch
    if command -v systemd-inhibit >/dev/null 2>&1; then
        systemd-inhibit \
            --what=idle:sleep:handle-lid-switch \
            --who="Quickshell StayAwake" \
            --why="User requested stay awake" \
            sleep infinity &
        echo "$!" > "$PID_FILE"
    fi

    # 2. D-Bus inhibitor for hypridle / org.freedesktop.ScreenSaver
    if command -v busctl >/dev/null 2>&1; then
        local out cookie
        out=$(busctl --user call org.freedesktop.ScreenSaver /org/freedesktop/ScreenSaver org.freedesktop.ScreenSaver Inhibit ss "Quickshell StayAwake" "Inhibit screen lock" 2>/dev/null || true)
        cookie=$(echo "$out" | awk '{print $2}')
        if [[ -n "$cookie" ]]; then
            echo "$cookie" > "$COOKIE_FILE"
        fi
    fi
}

stop() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE" 2>/dev/null || true)
        if [[ -n "$pid" ]]; then
            kill "$pid" 2>/dev/null || true
        fi
        rm -f "$PID_FILE"
    fi

    if [[ -f "$COOKIE_FILE" ]]; then
        local cookie
        cookie=$(cat "$COOKIE_FILE" 2>/dev/null || true)
        if [[ -n "$cookie" ]] && command -v busctl >/dev/null 2>&1; then
            busctl --user call org.freedesktop.ScreenSaver /org/freedesktop/ScreenSaver org.freedesktop.ScreenSaver UnInhibit u "$cookie" 2>/dev/null || true
        fi
        rm -f "$COOKIE_FILE"
    fi
}

case "${1:-status}" in
    on)
        start
        ;;
    off)
        stop
        ;;
    toggle)
        if is_active; then
            stop
        else
            start
        fi
        ;;
    status)
        if is_active; then
            echo "active"
        else
            echo "inactive"
        fi
        ;;
    *)
        echo "Usage: $0 {on|off|toggle|status}" >&2
        exit 1
        ;;
esac
