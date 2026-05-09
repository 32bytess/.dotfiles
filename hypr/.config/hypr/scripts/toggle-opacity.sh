#!/usr/bin/env bash
set -euo pipefail

ADDR=$(hyprctl activewindow -j | jq -r '.address // empty')
[[ -z "$ADDR" ]] && exit 0

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr_opacity_${ADDR}"

if [[ -f "$STATE_FILE" ]]; then
    # Restore config-driven opacity
    hyprctl setprop "address:${ADDR}" opacity 0 lock:0
    rm "$STATE_FILE"
else
    # Force fully opaque
    hyprctl setprop "address:${ADDR}" opacity 1 lock:1
    touch "$STATE_FILE"
fi
