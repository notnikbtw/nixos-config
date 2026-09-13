#!/usr/bin/env bash
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { 'rgba(7aa2f7ee)', 'rgba(bb9af7ee)' }, angle = 45 }, inactive_border = 'rgba(24283baa)' } } })" 2>/dev/null || hyprctl keyword general:col.active_border "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg" 2>/dev/null || true
