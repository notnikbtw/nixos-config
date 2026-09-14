#!/usr/bin/env bash
set -euo pipefail

REMINDERS_DIR="${XDG_RUNTIME_DIR:-/tmp}/reminders"
mkdir -p "$REMINDERS_DIR"

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/hub.rasi"
if [ -f "$ROFI_THEME" ]; then
    ROFI_CMD="rofi -dmenu -theme $ROFI_THEME"
else
    ROFI_CMD="rofi -dmenu"
fi

parse_to_seconds() {
    local str="$1"
    local num unit
    if [[ "$str" =~ ^([0-9]+)([smhSMH]?)$ ]]; then
        num="${BASH_REMATCH[1]}"
        unit="${BASH_REMATCH[2],,}"
        case "$unit" in
            s) echo "$num" ;;
            h) echo "$((num * 3600))" ;;
            m|"") echo "$((num * 60))" ;;
        esac
    else
        echo 0
    fi
}

format_seconds() {
    local s="$1"
    if [[ "$s" -le 0 ]]; then
        echo "0s"
        return
    fi
    local h=$(( s / 3600 ))
    local m=$(( (s % 3600) / 60 ))
    local sec=$(( s % 60 ))

    if [[ "$h" -gt 0 ]]; then
        printf "%dh %02dm\n" "$h" "$m"
    elif [[ "$m" -gt 0 ]]; then
        printf "%02dm %02ds\n" "$m" "$sec"
    else
        printf "%ds\n" "$sec"
    fi
}

cancel_all() {
    local count=0
    for file in "$REMINDERS_DIR"/*.json; do
        [[ -f "$file" ]] || continue
        local pid
        pid=$(jq -r '.pid' "$file" 2>/dev/null || true)
        if [[ -n "$pid" && "$pid" != "null" ]]; then
            kill "$pid" 2>/dev/null || true
            ((count++)) || true
        fi
        rm -f "$file"
    done
    notify-send -i alarm-clock "Reminders" "Cancelled all active timers ($count)"
}

start_timer() {
    local raw_time="$1"
    local message="${2:-Timer finished}"
    local seconds
    seconds=$(parse_to_seconds "$raw_time")

    if [[ "$seconds" -le 0 ]]; then
        notify-send -u critical -i dialog-error "Reminder" "Invalid duration: $raw_time"
        return 1
    fi

    local id="$(date +%s)_$RANDOM"
    local datafile="$REMINDERS_DIR/$id.json"
    local now
    now=$(date +%s)
    local target=$(( now + seconds ))

    (
        local my_pid=$$
        jq -c -n \
            --arg id "$id" \
            --argjson pid "$my_pid" \
            --argjson created "$now" \
            --argjson target "$target" \
            --arg duration "$raw_time" \
            --arg label "$message" \
            '{id: $id, pid: $pid, created: $created, target: $target, duration: $duration, label: $label}' > "$datafile"

        sleep "$seconds"
        notify-send -u critical -a "Timer" -i alarm-clock "⏰ Time's Up!" "$message"
        rm -f "$datafile"
    ) &

    notify-send -i alarm-clock "Timer Set ($raw_time)" "$message"
}

show_list_notification() {
    local now
    now=$(date +%s)
    local lines=""
    local count=0

    for file in "$REMINDERS_DIR"/*.json; do
        [[ -f "$file" ]] || continue
        local pid target label
        pid=$(jq -r '.pid' "$file" 2>/dev/null || true)
        target=$(jq -r '.target' "$file" 2>/dev/null || true)
        label=$(jq -r '.label' "$file" 2>/dev/null || true)

        if [[ -n "$pid" && "$pid" != "null" ]] && kill -0 "$pid" 2>/dev/null; then
            local rem=$(( target - now ))
            if [[ "$rem" -gt 0 ]]; then
                local rem_str
                rem_str=$(format_seconds "$rem")
                lines+="• $rem_str — $label\n"
                ((count++)) || true
            fi
        fi
    done

    if [[ "$count" -gt 0 ]]; then
        notify-send -i alarm-clock "Active Timers ($count)" "$(echo -e "$lines")"
    else
        notify-send -i alarm-clock "Active Timers" "No active timers running"
    fi
}

count_active_timers() {
    local count=0
    local now
    now=$(date +%s)
    for file in "$REMINDERS_DIR"/*.json; do
        [[ -f "$file" ]] || continue
        local pid target
        pid=$(jq -r '.pid' "$file" 2>/dev/null || true)
        target=$(jq -r '.target' "$file" 2>/dev/null || true)
        if [[ -n "$pid" && "$pid" != "null" ]] && kill -0 "$pid" 2>/dev/null; then
            if [[ -n "$target" && "$target" -gt "$now" ]]; then
                ((count++)) || true
            else
                rm -f "$file"
            fi
        else
            rm -f "$file"
        fi
    done
    echo "$count"
}

manage_active_timers() {
    while true; do
        local now
        now=$(date +%s)
        local timer_lines=()
        local file_map=()

        for file in "$REMINDERS_DIR"/*.json; do
            [[ -f "$file" ]] || continue
            local pid target label duration
            pid=$(jq -r '.pid' "$file" 2>/dev/null || true)
            target=$(jq -r '.target' "$file" 2>/dev/null || true)
            label=$(jq -r '.label' "$file" 2>/dev/null || true)
            duration=$(jq -r '.duration' "$file" 2>/dev/null || true)

            if [[ -z "$pid" || "$pid" == "null" ]] || ! kill -0 "$pid" 2>/dev/null; then
                rm -f "$file"
                continue
            fi

            local remaining=$(( target - now ))
            if [[ "$remaining" -gt 0 ]]; then
                local rem_str
                rem_str=$(format_seconds "$remaining")
                local display="󰔛  $rem_str remaining — $label ($duration)"
                timer_lines+=("$display")
                file_map+=("$file")
            else
                rm -f "$file"
            fi
        done

        if [[ ${#timer_lines[@]} -eq 0 ]]; then
            notify-send -i alarm-clock "Reminders" "No active timers running"
            return 0
        fi

        local menu_options="󰌌  Back\n❌ Cancel All Timers"
        for item in "${timer_lines[@]}"; do
            menu_options+="\n$item"
        done

        local chosen
        chosen=$(echo -e "$menu_options" | $ROFI_CMD -p "Active Timers")
        [[ -z "$chosen" || "$chosen" == *"Back"* ]] && return 0

        if [[ "$chosen" == *"Cancel All"* ]]; then
            cancel_all
            return 0
        fi

        for idx in "${!timer_lines[@]}"; do
            if [[ "${timer_lines[$idx]}" == "$chosen" ]]; then
                local sel_file="${file_map[$idx]}"
                local sel_label
                sel_label=$(jq -r '.label' "$sel_file" 2>/dev/null || true)
                local action
                action=$(echo -e "󰅖  Cancel this timer\n󰌌  Back" | $ROFI_CMD -p "Timer: $sel_label")
                if [[ "$action" == *"Cancel this timer"* ]]; then
                    local sel_pid
                    sel_pid=$(jq -r '.pid' "$sel_file" 2>/dev/null || true)
                    kill "$sel_pid" 2>/dev/null || true
                    rm -f "$sel_file"
                    notify-send -i alarm-clock "Reminder Cancelled" "Cancelled: $sel_label"
                fi
                break
            fi
        done
    done
}

# CLI Commands
if [[ $# -ge 1 ]]; then
    case "$1" in
        cancel)
            cancel_all
            exit 0
            ;;
        list|show|status)
            show_list_notification
            exit 0
            ;;
        manage)
            manage_active_timers
            exit 0
            ;;
        *)
            start_timer "$1" "${2:-Reminder}"
            exit 0
            ;;
    esac
fi

# Interactive Rofi mode
active_count=$(count_active_timers)

options=""
if [[ "$active_count" -gt 0 ]]; then
    options+="📋 View Active Timers ($active_count)\n"
fi
options+="🍅 25m  Pomodoro (Work)\n☕ 5m   Short Break\n🌴 15m  Long Break\n🍵 10m  Tea / Coffee\n💧 30m  Hydrate & Stretch\n🎯 45m  Deep Work\n📋 60m  1 Hour Task"
if [[ "$active_count" -gt 0 ]]; then
    options+="\n❌ Cancel All Active Timers"
fi

chosen=$(echo -e "$options" | $ROFI_CMD -p "Timer / Reminder (e.g. 20m Call doc)")

[[ -z "$chosen" ]] && exit 0

if [[ "$chosen" == *"View Active Timers"* ]]; then
    manage_active_timers
    exit 0
elif [[ "$chosen" == *"Cancel All"* ]]; then
    cancel_all
    exit 0
fi

if [[ "$chosen" =~ ([0-9]+[smhSMH]?) ]]; then
    time_part="${BASH_REMATCH[1]}"
    label_part=$(echo "$chosen" | sed -E 's/^[^\ ]+\ +[0-9]+[smhSMH]?\ +//' | sed 's/^[[:space:]]*//')
    if [[ -z "$label_part" || "$label_part" == "$chosen" ]]; then
        label_part="Reminder ($time_part)"
    fi
    start_timer "$time_part" "$label_part"
else
    time_part=$(echo "$chosen" | awk '{print $1}')
    label_part=$(echo "$chosen" | cut -d' ' -f2-)
    if [[ "$label_part" == "$time_part" ]]; then
        label_part="Reminder"
    fi
    start_timer "$time_part" "$label_part"
fi
