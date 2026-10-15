#!/usr/bin/env bash

THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/themes"
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/wallpapers.rasi"
CURRENT="$THEMES_DIR/current-wallpaper.png"

wallpapers=()
while IFS= read -r -d '' file; do
    wallpapers+=("$file")
done < <(find -L "$HOME/Pictures/Wallpapers" "$THEMES_DIR/current/wallpapers" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 2>/dev/null | sort -z)

if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send -u low -a "Wallpaper" "No wallpapers found" "Add images to ~/Pictures/Wallpapers" 2>/dev/null || true
    exit 0
fi

current_wall=""
if [ -L "$CURRENT" ]; then
    current_wall="$(readlink -f "$CURRENT" 2>/dev/null)"
fi

selected_row=0
declare -A wall_map
entries=""
index=0

for img in "${wallpapers[@]}"; do
    fname=$(basename "$img")
    label="${fname%.*}"
    clean_label=$(echo "$label" | sed -E 's/^[0-9]+[-_]?//' | tr '_-' ' ')
    clean_label="$(echo "$clean_label" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"
    if [ -z "$clean_label" ]; then
        clean_label="$fname"
    fi

    if [ -n "${wall_map["$clean_label"]}" ]; then
        clean_label="$clean_label ($fname)"
    fi

    wall_map["$clean_label"]="$img"
    entries+="${clean_label}\0icon\x1f${img}\n"

    if [ "$(readlink -f "$img")" = "$current_wall" ]; then
        selected_row=$index
    fi
    ((index++))
done

chosen=$(printf "%b" "$entries" | rofi -dmenu -i -p "󰸉 Wallpaper" -show-icons -theme "$ROFI_THEME" -selected-row "$selected_row")

if [ -z "$chosen" ]; then
    exit 0
fi

SELECTED="${wall_map["$chosen"]}"
if [ -z "$SELECTED" ] || [ ! -f "$SELECTED" ]; then
    exit 1
fi

ln -sfn "$SELECTED" "$CURRENT"

if ! pgrep -x awww-daemon >/dev/null 2>&1; then
    awww-daemon &
    sleep 0.3
fi

awww img "$SELECTED" --transition-type fade --transition-duration 0.3 --transition-fps 144

notify-send -a "Wallpaper" -i "$SELECTED" "Wallpaper changed" "$chosen" 2>/dev/null || true
