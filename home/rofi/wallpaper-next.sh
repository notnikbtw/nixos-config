#!/usr/bin/env bash

THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/themes"
STATE_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/themes"

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

if [ ${#wallpapers[@]} -eq 0 ] && [ -f "$THEMES_DIR/$THEME/wallpaper.png" ]; then
    wallpapers+=("$THEMES_DIR/$THEME/wallpaper.png")
fi

TOTAL=${#wallpapers[@]}
if [ "$TOTAL" -eq 0 ]; then
    notify-send -u low -a "Wallpaper" "No wallpapers found for ${THEME^}" 2>/dev/null || true
    exit 0
fi

# 3. Find current index
current_wall=""
if [ -f "$STATE_THEME_DIR/wallpaper" ]; then
    current_wall="$(cat "$STATE_THEME_DIR/wallpaper" 2>/dev/null)"
fi
if [ -z "$current_wall" ] && [ -L "$THEMES_DIR/current-wallpaper.png" ]; then
    current_wall="$(readlink -f "$THEMES_DIR/current-wallpaper.png" 2>/dev/null)"
fi

index=-1
for i in "${!wallpapers[@]}"; do
    if [ "${wallpapers[$i]}" = "$current_wall" ]; then
        index=$i
        break
    fi
done

if [ "$index" -eq -1 ]; then
    next_index=0
else
    next_index=$(( (index + 1) % TOTAL ))
fi

SELECTED="${wallpapers[$next_index]}"

# 4. Save state & symlink
echo "$SELECTED" > "$STATE_THEME_DIR/wallpaper"
echo "$THEME" > "$STATE_BASE/current-theme"
ln -sfn "$SELECTED" "$THEMES_DIR/current-wallpaper.png"

# 5. Apply wallpaper
if ! pgrep -f awww-daemon >/dev/null 2>&1; then
    systemd-run --user --unit=awww-daemon awww-daemon 2>/dev/null || awww-daemon &
    sleep 0.3
fi

if command -v awww >/dev/null 2>&1; then
    awww img "$SELECTED" --transition-type fade --transition-duration 0.3 --transition-fps 144
elif command -v swww >/dev/null 2>&1; then
    swww img "$SELECTED" --transition-type fade --transition-duration 0.3 --transition-fps 144
fi

fname=$(basename "$SELECTED")
label="${fname%.*}"
clean_label=$(echo "$label" | sed -E 's/^[0-9]+[-_]?//' | tr '_-' ' ')
clean_label="$(echo "$clean_label" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"

notify-send -a "Wallpaper" -i "$SELECTED" "Wallpaper cycled ($((next_index + 1))/$TOTAL)" "$clean_label (${THEME^})" 2>/dev/null || true
