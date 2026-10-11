#!/usr/bin/env bash

theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/calc.rasi"

exec rofi -show calc -modi calc -no-show-match -no-sort \
    -theme "$theme" \
    -calc-command "echo -n '{result}' | wl-copy"
