#!/usr/bin/env bash
set -euo pipefail

OPACITY=$(grep -Po '(?<=set \$opacity )\S+' "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config" 2>/dev/null || echo 0.92)
CON_ID=$(swaymsg -t get_tree | jq '.. | objects | select(.focused == true) | .id // empty')
[[ -z "$CON_ID" ]] && exit 0

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/sway_opacity_disabled_${CON_ID}"

if [[ -f "$STATE_FILE" ]]; then
  swaymsg "[con_id=${CON_ID}] opacity ${OPACITY}"
  rm "$STATE_FILE"
else
  swaymsg "[con_id=${CON_ID}] opacity 1"
  touch "$STATE_FILE"
fi
