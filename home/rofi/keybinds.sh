#!/usr/bin/env bash
set -euo pipefail

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/hub.rasi"

bindings=(
    "󰌌  Super + Return             Open Terminal (Kitty)"
    "󰌌  Super + \`                  Toggle Quake Scratchpad"
    "󰌌  Super + Space              App Launcher (Rofi)"
    "󰌌  Super + Alt + Space        System Hub Menu"
    "󰌌  Super + E                  File Manager (Thunar)"
    "󰌌  Super + Y                  Terminal File Manager (Yazi)"
    "󰌌  Super + C                  Close Window"
    "󰌌  Super + F                  Toggle Fullscreen"
    "󰌌  Super + Shift + V          Toggle Floating Window"
    "󰌌  Super + V                  Clipboard History"
    "󰌌  Super + Ctrl + R           Quick Reminders / Pomodoro"
    "󰌌  Super + Ctrl + Alt + R     View / Manage Active Timers"
    "󰌌  Super + Alt + R            Record Screen (Fullscreen)"
    "󰌌  Super + Shift + R          Record Screen (Select Area)"
    "󰌌  Super + Shift + M          Toggle Microphone Mute"
    "󰌌  Super + Escape             Power Menu / Exit"
    "󰌌  Super + /                  Keybindings Cheat Sheet"
    "󰌌  Print                      Take Screenshot"
    "󰌌  Super + Shift + C          Color Picker (Hyprpicker)"
    "󰌌  Super + Shift + O          OCR Text Extractor"
    "󰌌  Super + 1..9               Switch to Workspace 1..9"
    "󰌌  Super + Shift + 1..9       Move Window to Workspace 1..9"
    "󰌌  Super + Left/Right/Up/Down Focus Window in Direction"
    "󰌌  Super + H/J/K/L            Focus Window (Vim keys)"
    "󰌌  Super + Shift + H/J/K/L    Move Window (Vim keys)"
    "󰌌  Super + Mouse Left (Hold)  Drag Floating Window"
    "󰌌  Super + Mouse Right (Hold) Resize Floating Window"
    "󰌌  Super + Scroll             Cycle Workspaces"
)

formatted=$(printf "%s\n" "${bindings[@]}")

if [[ -f "$ROFI_THEME" ]]; then
    chosen=$(echo -e "$formatted" | rofi -dmenu -i -p "Shortcuts" -theme "$ROFI_THEME" || true)
else
    chosen=$(echo -e "$formatted" | rofi -dmenu -i -p "Shortcuts" || true)
fi

case "$chosen" in
    *"Open Terminal"*)
        kitty &
        ;;
    *"App Launcher"*)
        rofi -show drun &
        ;;
    *"File Manager"*)
        thunar &
        ;;
    *"Terminal File Manager"*)
        kitty -e yazi &
        ;;
    *"Clipboard History"*)
        cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy &
        ;;
    *"Reminders"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/reminder.sh" &
        ;;
    *"Active Timers"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/reminder.sh" manage &
        ;;
    *"Record Screen (Fullscreen)"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/scripts/record-toggle.sh" fullscreen &
        ;;
    *"Record Screen (Select Area)"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/scripts/record-toggle.sh" region &
        ;;
    *"Microphone Mute"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/scripts/osd-mic.sh" &
        ;;
    *"Color Picker"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/color-picker.sh" &
        ;;
    *"OCR Text Extractor"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/ocr-extract.sh" &
        ;;
    *"System Hub Menu"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/hub.sh" &
        ;;
    *"Power Menu"*)
        "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/powermenu.sh" &
        ;;
esac
