#!/usr/bin/env bash

THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/themes"
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes.rasi"

if [ ! -e "$THEMES_DIR/current" ]; then
    ln -sfn "$THEMES_DIR/gruvbox" "$THEMES_DIR/current"
fi

options="󰉼  Gruvbox\n󰉼  Kanagawa\n󰉼  Miasma"

if [ -n "$1" ]; then
    chosen="$1"
elif [ -f "$ROFI_THEME" ]; then
    chosen="$(echo -e "$options" | rofi -dmenu -p "Theme" -theme "$ROFI_THEME")"
else
    chosen="$(echo -e "$options" | rofi -dmenu -p "Theme")"
fi

case "$chosen" in
    *"Gruvbox"*|"gruvbox")
        THEME="gruvbox"
        ;;
    *"Kanagawa"*|"kanagawa")
        THEME="kanagawa"
        ;;
    *"Miasma"*|"miasma")
        THEME="miasma"
        ;;
    *)
        exit 0
        ;;
esac

TARGET="$THEMES_DIR/$THEME"

if [ ! -d "$TARGET" ]; then
    notify-send -u critical "Theme Switcher" "Directory not found: $TARGET" 2>/dev/null || true
    exit 1
fi

ln -sfn "$TARGET" "$THEMES_DIR/current"

QUICKSHELL_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
if [ -d "$QUICKSHELL_DIR" ] && [ -f "$TARGET/Theme.qml" ]; then
    ln -sfn "$TARGET/Theme.qml" "$QUICKSHELL_DIR/Theme.qml"
fi

if ! pgrep -f awww-daemon >/dev/null 2>&1; then
    systemd-run --user --unit=awww-daemon awww-daemon 2>/dev/null || awww-daemon &
    sleep 0.3
fi

STATE_BASE="${XDG_STATE_HOME:-$HOME/.local/state}/themes"
STATE_THEME_DIR="$STATE_BASE/$THEME"
mkdir -p "$STATE_THEME_DIR"
echo "$THEME" > "$STATE_BASE/current-theme"

WALLPAPER=""
if [ -f "$STATE_THEME_DIR/wallpaper" ]; then
    saved_wall="$(cat "$STATE_THEME_DIR/wallpaper" 2>/dev/null)"
    if [ -n "$saved_wall" ] && [ -f "$saved_wall" ]; then
        WALLPAPER="$saved_wall"
    fi
fi

if [ -z "$WALLPAPER" ]; then
    for dir in "$HOME/Pictures/Wallpapers/$THEME" "$TARGET/wallpapers"; do
        if [ -d "$dir" ]; then
            first_wall="$(find -L "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort | head -n 1)"
            if [ -n "$first_wall" ] && [ -f "$first_wall" ]; then
                WALLPAPER="$first_wall"
                break
            fi
        fi
    done
fi

if [ -z "$WALLPAPER" ] && [ -f "$TARGET/wallpaper.png" ]; then
    WALLPAPER="$TARGET/wallpaper.png"
fi

if [ -n "$WALLPAPER" ]; then
    echo "$WALLPAPER" > "$STATE_THEME_DIR/wallpaper"
    ln -sfn "$WALLPAPER" "$THEMES_DIR/current-wallpaper.png"

    if command -v awww >/dev/null 2>&1; then
        awww img "$WALLPAPER" --transition-type fade --transition-duration 0.3 --transition-fps 144
    fi
fi

pkill -USR1 -f kitty 2>/dev/null || true

if command -v tmux >/dev/null 2>&1 && [ -f "$TARGET/tmux.conf" ]; then
    tmux source-file "$TARGET/tmux.conf" 2>/dev/null || true
fi

if [ -f "$TARGET/borders.sh" ]; then
    bash "$TARGET/borders.sh" 2>/dev/null || true
fi

if pidof quickshell >/dev/null 2>&1; then
    pkill quickshell 2>/dev/null || true
    while pidof quickshell >/dev/null 2>&1; do
        sleep 0.05
    done
    quickshell >/dev/null 2>&1 &
fi

if [ -f "$TARGET/theme.json" ] && command -v jq >/dev/null 2>&1; then
    GTK_THEME=$(jq -r '.gtkTheme // empty' "$TARGET/theme.json")
    ICON_THEME=$(jq -r '.iconTheme // empty' "$TARGET/theme.json")
    if [ -n "$GTK_THEME" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
        dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'" 2>/dev/null || true
    fi
    if [ -n "$ICON_THEME" ]; then
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null || true
        dconf write /org/gnome/desktop/interface/icon-theme "'$ICON_THEME'" 2>/dev/null || true
    fi
fi

if [ -f "$TARGET/gtk3.ini" ]; then
    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    ln -sfn "$TARGET/gtk3.ini" "$HOME/.config/gtk-3.0/settings.ini"
    ln -sfn "$TARGET/gtk3.ini" "$HOME/.config/gtk-4.0/settings.ini"
fi

pkill -SIGUSR2 -f btop 2>/dev/null || true

HOOKS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/themes/hooks.d"
if [ -d "$HOOKS_DIR" ]; then
    for hook in "$HOOKS_DIR"/*; do
        if [ -x "$hook" ]; then
            "$hook" "$THEME" >/dev/null 2>&1 &
        fi
    done
fi

notify-send -a "Theme Switcher" -i "$WALLPAPER" "Theme changed" "Switched to ${THEME^}" 2>/dev/null || true
