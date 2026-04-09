#!/bin/bash
# Toggle blur for the currently focused window

CON_ID=$(swaymsg -t get_tree | jq '.. | objects | select(.focused == true) | .id')
STATE_FILE="/tmp/sway_blur_disabled_${CON_ID}"

if [ -f "$STATE_FILE" ]; then
  swaymsg "[con_id=${CON_ID}] blur enable"
  rm "$STATE_FILE"
else
  swaymsg "[con_id=${CON_ID}] blur disable"
  touch "$STATE_FILE"
fi
