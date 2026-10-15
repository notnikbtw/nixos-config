#!/usr/bin/env bash

#   Enter       copy the selected entry
#   Alt+Delete  remove the selected entry and keep the list open
#   First row   clear the whole history

clear_label="󰆴  Clear History"

confirm_clear() {
    local answer
    answer="$(printf '%s\n' "No" "Yes, clear everything" | rofi -dmenu -i -p "Clear clipboard history?")"
    if [ "$answer" = "Yes, clear everything" ]; then
        cliphist wipe
        notify-send -a "Clipboard" -i edit-clear "Clipboard" "History cleared" 2>/dev/null || true
    fi
}

while true; do
    history="$(cliphist list)"

    if [ -z "$history" ]; then
        notify-send -a "Clipboard" -i edit-paste "Clipboard" "History is empty" 2>/dev/null || true
        exit 0
    fi

    choice="$({ printf '%s\n' "$clear_label"; printf '%s\n' "$history"; } \
        | rofi -dmenu -i -p "Clipboard" -kb-custom-1 "Alt+Delete")"
    code=$?

    case "$code" in
        0)
            if [ "$choice" = "$clear_label" ]; then
                confirm_clear
            else
                printf '%s' "$choice" | cliphist decode | wl-copy
            fi
            exit 0
            ;;
        10)
            # Alt+Delete: drop the entry, then show the list again
            [ "$choice" != "$clear_label" ] && printf '%s' "$choice" | cliphist delete
            ;;
        *)
            exit 0
            ;;
    esac
done
