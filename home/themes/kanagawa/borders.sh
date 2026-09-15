#!/usr/bin/env bash
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { 'rgba(957fb8ee)', 'rgba(7e9cd8ee)' }, angle = 45 }, inactive_border = 'rgba(2a2a37aa)' } } })" 2>/dev/null || hyprctl keyword general:col.active_border "rgba(957fb8ee) rgba(7e9cd8ee) 45deg" 2>/dev/null || true
