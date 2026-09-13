#!/usr/bin/env bash
# Hyprland session bootstrap: defaults, themes, fonts, and core daemons


init_theme() {
    # Base theme directory symlink (default: gruvbox)
    if [ ! -e ~/.config/themes/current ]; then
        ln -sfn ~/.config/themes/gruvbox ~/.config/themes/current
    fi

    # Quickshell theme symlink
    if [ ! -e ~/.config/quickshell/Theme.qml ]; then
        mkdir -p ~/.config/quickshell
        ln -sfn ~/.config/themes/current/Theme.qml ~/.config/quickshell/Theme.qml
    fi

    # GTK 3/4 settings symlinks
    if [ -f ~/.config/themes/current/gtk3.ini ]; then
        mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
        ln -sfn ~/.config/themes/current/gtk3.ini ~/.config/gtk-3.0/settings.ini
        ln -sfn ~/.config/themes/current/gtk3.ini ~/.config/gtk-4.0/settings.ini
    fi

    # Wallpaper symlink
    if [ ! -e ~/.config/themes/current-wallpaper.png ]; then
        if [ -d ~/.config/themes/current/wallpapers ]; then
            first_wp=$(find -L ~/.config/themes/current/wallpapers -maxdepth 1 -type f 2>/dev/null | sort | head -n 1)
            if [ -n "$first_wp" ]; then
                ln -sfn "$first_wp" ~/.config/themes/current-wallpaper.png
            fi
        fi
        if [ ! -e ~/.config/themes/current-wallpaper.png ] && [ -f ~/.config/themes/current/wallpaper.png ]; then
            ln -sfn ~/.config/themes/current/wallpaper.png ~/.config/themes/current-wallpaper.png
        fi
    fi
}

init_fonts() {
    # Default Kitty font configuration
    if [ ! -f ~/.config/kitty/font.conf ]; then
        mkdir -p ~/.config/kitty
        printf "font_family JetBrainsMono Nerd Font\nfont_size 12.0\n" > ~/.config/kitty/font.conf
    fi

    # Default Rofi font configuration
    if [ ! -f ~/.config/rofi/font.rasi ]; then
        mkdir -p ~/.config/rofi
        printf '* { font: "JetBrainsMono Nerd Font 12"; }\n' > ~/.config/rofi/font.rasi
    fi

    # Default Quickshell font configuration
    if [ ! -f ~/.config/quickshell/FontConfig.qml ]; then
        mkdir -p ~/.config/quickshell
        printf 'pragma Singleton\nimport QtQuick\n\nQtObject {\n    readonly property string family: "JetBrainsMono Nerd Font"\n    readonly property int sizeNormal: 12\n    readonly property int sizeSmall: 10\n}\n' > ~/.config/quickshell/FontConfig.qml
    fi
}

start_daemons() {
    # Quickshell status bar, notifications & OSD
    if ! pidof quickshell >/dev/null; then
        quickshell &
    fi

    # awww wallpaper daemon
    if ! pidof awww-daemon >/dev/null; then
        awww-daemon &
        sleep 0.4
    fi

    # Restore wallpaper
    if command -v awww >/dev/null 2>&1; then
        awww restore 2>/dev/null || \
        awww img ~/.config/themes/current-wallpaper.png 2>/dev/null || \
        awww img ~/.config/themes/current/wallpaper.png 2>/dev/null || true
    fi

    # Dynamic Hyprland border colors
    if [ -f ~/.config/themes/current/borders.sh ]; then
        bash ~/.config/themes/current/borders.sh &
    fi
}

init_theme
init_fonts
start_daemons
