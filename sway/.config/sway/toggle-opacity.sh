#!/bin/bash
# Toggle opacity and blur for the currently focused window

CON_ID=$(swaymsg -t get_tree | jq '.. | objects | select(.focused == true) | .id')
STATE_FILE="/tmp/sway_opacity_disabled_${CON_ID}"

if [ -f "$STATE_FILE" ]; then
  swaymsg "[con_id=${CON_ID}] opacity 0.9"
  swaymsg "[con_id=${CON_ID}] blur enable"
  rm "$STATE_FILE"
else
  swaymsg "[con_id=${CON_ID}] opacity 1"
  swaymsg "[con_id=${CON_ID}] blur disable"
  touch "$STATE_FILE"
fi
