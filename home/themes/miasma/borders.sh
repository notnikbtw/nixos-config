#!/usr/bin/env bash
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { 'rgba(78997aee)', 'rgba(bca063ee)' }, angle = 45 }, inactive_border = 'rgba(2b2b2baa)' } } })" 2>/dev/null || hyprctl keyword general:col.active_border "rgba(78997aee) rgba(bca063ee) 45deg" 2>/dev/null || true
