#!/usr/bin/env bash

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/hub.rasi"

if [ -f "$ROFI_THEME" ]; then
    ROFI_CMD="rofi -dmenu -theme $ROFI_THEME"
else
    ROFI_CMD="rofi -dmenu"
fi

# Helper: Toggle Night Light (hyprsunset)
toggle_nightlight() {
    if pgrep -x hyprsunset >/dev/null 2>&1; then
        pkill -x hyprsunset
        notify-send -a "Night Light" -i weather-clear-night "Night Light" "Disabled" 2>/dev/null || true
    else
        hyprsunset -t 4500 >/dev/null 2>&1 &
        notify-send -a "Night Light" -i weather-clear-night "Night Light" "Enabled (4500K)" 2>/dev/null || true
    fi
}

# Submenu: Customization
menu_customization() {
    while true; do
        local options="󰌌  Back\n󰉼  Themes\n󰸉  Wallpapers\n󰑐  Next Wallpaper\n  Fonts & Size\n󰃠  Night Light (Toggle)"
        local chosen
        chosen="$(echo -e "$options" | $ROFI_CMD -p "Customize")"
        case "$chosen" in
            *"Back"*|"")
                return 0
                ;;
            *"Themes"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/theme-switcher.sh"
                exit 0
                ;;
            *"Wallpapers"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/wallpaper-switcher.sh"
                exit 0
                ;;
            *"Next Wallpaper"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/wallpaper-next.sh"
                exit 0
                ;;
            *"Fonts"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/font-switcher.sh"
                exit 0
                ;;
            *"Night Light"*)
                toggle_nightlight
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

# Submenu: Settings
menu_settings() {
    while true; do
        local options="󰌌  Back\n  Audio & Volume (Pavucontrol)\n󰂯  Bluetooth (Blueman)\n󰖩  Network Connections\n󰍹  Displays & Monitors"
        local chosen
        chosen="$(echo -e "$options" | $ROFI_CMD -p "Settings")"
        case "$chosen" in
            *"Back"*|"")
                return 0
                ;;
            *"Audio"*)
                pavucontrol >/dev/null 2>&1 &
                exit 0
                ;;
            *"Bluetooth"*)
                blueman-manager >/dev/null 2>&1 &
                exit 0
                ;;
            *"Network"*)
                nm-connection-editor >/dev/null 2>&1 &
                exit 0
                ;;
            *"Displays"*)
                if command -v wdisplays >/dev/null 2>&1; then
                    wdisplays >/dev/null 2>&1 &
                else
                    hyprctl monitors >/dev/null 2>&1 || true
                    notify-send -a "Display" -i video-display "Monitors" "$(hyprctl monitors | grep 'Monitor' | cut -d' ' -f2)" 2>/dev/null || true
                fi
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

# Main Menu: Control Hub
main_menu() {
    while true; do
        local options="󰉼  Customization\n  Settings\n󰌌  Shortcuts & Keybinds\n󰔛  Reminders & Pomodoro\n󰅍  Clipboard History\n󰹑  Take Screenshot\n  Power Menu"
        local chosen
        chosen="$(echo -e "$options" | $ROFI_CMD -p "Hub")"

        case "$chosen" in
            *"Customization"*)
                menu_customization
                ;;
            *"Settings"*)
                menu_settings
                ;;
            *"Shortcuts"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/keybinds.sh"
                exit 0
                ;;
            *"Reminders"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/reminder.sh"
                exit 0
                ;;
            *"Clipboard"*)
                cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
                exit 0
                ;;
            *"Screenshot"*)
                local dir="$HOME/Pictures/Screenshots"
                mkdir -p "$dir"
                grim -g "$(slurp)" - | swappy -f - -o "$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
                exit 0
                ;;
            *"Power"*)
                "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/powermenu.sh"
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

main_menu
