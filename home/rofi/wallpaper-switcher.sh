#!/usr/bin/env bash

THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/themes"
STATE_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/themes"
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/wallpapers.rasi"

# 1. Resolve current theme
THEME=""
if [ -f "$STATE_BASE/current-theme" ]; then
    THEME=$(cat "$STATE_BASE/current-theme" 2>/dev/null)
fi

if [ -z "$THEME" ] && [ -L "$THEMES_DIR/current" ]; then
    THEME=$(basename "$(readlink -f "$THEMES_DIR/current")")
fi

if [ -z "$THEME" ]; then
    THEME="gruvbox"
fi

STATE_THEME_DIR="$STATE_BASE/$THEME"
mkdir -p "$STATE_THEME_DIR"

# 2. Gather wallpapers for current theme
DIRS=(
    "$HOME/Pictures/Wallpapers/$THEME"
    "$THEMES_DIR/$THEME/wallpapers"
)

wallpapers=()
while IFS= read -r -d '' file; do
    wallpapers+=("$file")
done < <(find -L "${DIRS[@]}" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 2>/dev/null | sort -z)

# Fallback to theme single wallpaper.png if wallpapers/ is empty
if [ ${#wallpapers[@]} -eq 0 ] && [ -f "$THEMES_DIR/$THEME/wallpaper.png" ]; then
    wallpapers+=("$THEMES_DIR/$THEME/wallpaper.png")
fi

if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send -u low -a "Wallpaper Switcher" "No wallpapers found" "Add wallpapers to ~/.config/themes/$THEME/wallpapers or ~/Pictures/Wallpapers/$THEME" 2>/dev/null || true
    exit 0
fi

# 3. Identify current wallpaper to preselect in Rofi
current_wall=""
if [ -f "$STATE_THEME_DIR/wallpaper" ]; then
    current_wall="$(cat "$STATE_THEME_DIR/wallpaper" 2>/dev/null)"
fi
if [ -z "$current_wall" ] && [ -L "$THEMES_DIR/current-wallpaper.png" ]; then
    current_wall="$(readlink -f "$THEMES_DIR/current-wallpaper.png" 2>/dev/null)"
fi

selected_row=0
declare -A wall_map
entries=""
index=0

for img in "${wallpapers[@]}"; do
    fname=$(basename "$img")
    label="${fname%.*}"
    # Format label nicely: strip index prefixes like '01-' and replace underscores/dashes with spaces
    clean_label=$(echo "$label" | sed -E 's/^[0-9]+[-_]?//' | tr '_-' ' ')
    clean_label="$(echo "$clean_label" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"
    if [ -z "$clean_label" ]; then
        clean_label="$fname"
    fi

    # Handle collision if any
    if [ -n "${wall_map["$clean_label"]}" ]; then
        clean_label="$clean_label ($fname)"
    fi

    wall_map["$clean_label"]="$img"
    entries+="${clean_label}\0icon\x1f${img}\n"

    if [ "$img" = "$current_wall" ]; then
        selected_row=$index
    fi
    ((index++))
done

# 4. Open Rofi menu
if [ -f "$ROFI_THEME" ]; then
    chosen=$(printf "%b" "$entries" | rofi -dmenu -i -p "󰸉 Wallpaper (${THEME^})" -show-icons -theme "$ROFI_THEME" -selected-row "$selected_row")
else
    chosen=$(printf "%b" "$entries" | rofi -dmenu -i -p "󰸉 Wallpaper (${THEME^})" -show-icons -selected-row "$selected_row")
fi

if [ -z "$chosen" ]; then
    exit 0
fi

SELECTED="${wall_map["$chosen"]}"
if [ -z "$SELECTED" ] || [ ! -f "$SELECTED" ]; then
    exit 1
fi

# 5. Save state and update symlink
echo "$SELECTED" > "$STATE_THEME_DIR/wallpaper"
echo "$THEME" > "$STATE_BASE/current-theme"
ln -sfn "$SELECTED" "$THEMES_DIR/current-wallpaper.png"

# 6. Apply wallpaper via awww / swww
if ! pgrep -f awww-daemon >/dev/null 2>&1; then
    systemd-run --user --unit=awww-daemon awww-daemon 2>/dev/null || awww-daemon &
    sleep 0.3
fi

if command -v awww >/dev/null 2>&1; then
    awww img "$SELECTED" --transition-type fade --transition-duration 0.3 --transition-fps 144
elif command -v swww >/dev/null 2>&1; then
    swww img "$SELECTED" --transition-type fade --transition-duration 0.3 --transition-fps 144
fi

notify-send -a "Wallpaper" -i "$SELECTED" "Wallpaper changed" "$chosen (${THEME^})" 2>/dev/null || true
