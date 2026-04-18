#!/usr/bin/env bash
set -euo pipefail

CON_ID=$(swaymsg -t get_tree | jq '.. | objects | select(.focused == true) | .id // empty')
[[ -z "$CON_ID" ]] && exit 0

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/sway_blur_disabled_${CON_ID}"

if [[ -f "$STATE_FILE" ]]; then
  swaymsg "[con_id=${CON_ID}] blur enable"
  rm "$STATE_FILE"
else
  swaymsg "[con_id=${CON_ID}] blur disable"
  touch "$STATE_FILE"
fi
