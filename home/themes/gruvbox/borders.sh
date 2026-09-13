#!/usr/bin/env bash
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { 'rgba(fabd2fee)', 'rgba(fe8019ee)' }, angle = 45 }, inactive_border = 'rgba(3c3836aa)' } } })" 2>/dev/null || hyprctl keyword general:col.active_border "rgba(fabd2fee) rgba(fe8019ee) 45deg" 2>/dev/null || true
