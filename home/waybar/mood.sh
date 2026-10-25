#!/usr/bin/env bash

offset_file="${XDG_RUNTIME_DIR:-/tmp}/waybar-mood-offset"

if [ "${1:-}" = "next" ]; then
    echo $(( $(cat "$offset_file" 2>/dev/null || echo 0) + 1 )) > "$offset_file"
    pkill -RTMIN+8 waybar
    exit 0
fi

cute=(":3" ">⩊<" "(⸝⸝0⸝⸝0⸝⸝)" "(⸝⸝⩌ ⤙ ⩌⸝⸝)" "ᗜ⩊ᗜ" "Meow :3" "(=^･ω･^=)" "ฅ^•ﻌ•^ฅ" "₍^. .^₎⟆" "(◕‿◕)" "(◠‿◠)")
sleepy=("(-_-) zzZ" "(ᴗ˳ᴗ) zzZ" "(˘ω˘) zzZ" "(=ᴗ˳ᴗ=) zzZ" "(︶｡︶✽)" "(っ- ‸ - ς)" "ᶻ (ᴗ_ᴗ)")

out() { printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$1" "$2" "$3"; }

pick() {
    local -n faces=$1
    local offset
    offset=$(cat "$offset_file" 2>/dev/null || echo 0)
    echo "${faces[$(( ( $(date +%s) / $2 + offset ) % ${#faces[@]} ))]}"
}

for bat in /sys/class/power_supply/BAT*; do
    [ -r "$bat/capacity" ] || continue
    cap=$(cat "$bat/capacity")
    status=$(cat "$bat/status")
    if [ "$status" = "Discharging" ] && [ "$cap" -le 15 ]; then
        out "(╥﹏╥)" "Battery low: $cap%, please plug me in" "sad"; exit 0
    fi
    if [ "$status" = "Charging" ]; then
        out "(⸝⸝⩌ ⤙ ⩌⸝⸝)" "Charging: $cap%" "happy"; exit 0
    fi
done

if awk -v c="$(nproc)" '{ exit !($1 > c * 0.8) }' /proc/loadavg; then
    out ">⩊<" "Working hard: load $(cut -d' ' -f1 /proc/loadavg)" "busy"; exit 0
fi

if [ "$(date +%-H)" -lt 6 ]; then
    out "$(pick sleepy 3600)" "It's late, time to sleep" "sleepy"; exit 0
fi

out "$(pick cute 300)" "Feeling cute" "cute"
