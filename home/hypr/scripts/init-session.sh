#!/usr/bin/env bash

init_wallpaper() {
    if [ ! -e ~/.config/themes/current-wallpaper.png ]; then
        ln -sfn ~/.config/themes/current/wallpapers/01-wallhaven.png ~/.config/themes/current-wallpaper.png
    fi
}

start_daemons() {
    if ! pidof awww-daemon >/dev/null; then
        awww-daemon &
        sleep 0.4
    fi

    if command -v awww >/dev/null 2>&1; then
        awww img ~/.config/themes/current-wallpaper.png 2>/dev/null || true
    fi
}

init_wallpaper
start_daemons
