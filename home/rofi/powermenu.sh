#!/usr/bin/env bash

# Options
lock="  Lock"
suspend="  Suspend"
logout="󰍃  Log Out"
reboot="  Restart"
shutdown="  Shut Down"

options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

theme_path="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/powermenu.rasi"

if [[ -f "$theme_path" ]]; then
    chosen="$(echo -e "$options" | rofi -dmenu -p "Power" -theme "$theme_path")"
else
    chosen="$(echo -e "$options" | rofi -dmenu -p "Power")"
fi

case "$chosen" in
    "$lock")
        pidof hyprlock || hyprlock
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        if command -v hyprshutdown >/dev/null 2>&1; then
            hyprshutdown
        else
            hyprctl dispatch exit
        fi
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
