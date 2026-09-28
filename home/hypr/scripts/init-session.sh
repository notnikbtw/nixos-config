#!/usr/bin/env bash

init_theme() {
    if [ ! -e ~/.config/themes/current ]; then
        ln -sfn ~/.config/themes/gruvbox ~/.config/themes/current
    fi

    if [ ! -e ~/.config/quickshell/Theme.qml ]; then
        mkdir -p ~/.config/quickshell
        ln -sfn ~/.config/themes/current/Theme.qml ~/.config/quickshell/Theme.qml
    fi

    if [ -f ~/.config/themes/current/gtk3.ini ]; then
        mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
        ln -sfn ~/.config/themes/current/gtk3.ini ~/.config/gtk-3.0/settings.ini
        ln -sfn ~/.config/themes/current/gtk3.ini ~/.config/gtk-4.0/settings.ini
    fi

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

start_daemons() {
    if ! pidof quickshell >/dev/null; then
        quickshell -d
    fi

    if ! pidof awww-daemon >/dev/null; then
        awww-daemon &
        sleep 0.4
    fi

    if command -v awww >/dev/null 2>&1; then
        awww restore 2>/dev/null || \
        awww img ~/.config/themes/current-wallpaper.png 2>/dev/null || \
        awww img ~/.config/themes/current/wallpaper.png 2>/dev/null || true
    fi

    if [ -f ~/.config/themes/current/borders.sh ]; then
        bash ~/.config/themes/current/borders.sh &
    fi
}

init_theme
start_daemons
