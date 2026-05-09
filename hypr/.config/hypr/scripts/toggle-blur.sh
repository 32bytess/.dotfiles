#!/usr/bin/env bash
set -euo pipefail

ADDR=$(hyprctl activewindow -j | jq -r '.address // empty')
[[ -z "$ADDR" ]] && exit 0

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr_blur_${ADDR}"

if [[ -f "$STATE_FILE" ]]; then
    hyprctl setprop "address:${ADDR}" noblur 0 lock:0
    rm "$STATE_FILE"
else
    hyprctl setprop "address:${ADDR}" noblur 1 lock:1
    touch "$STATE_FILE"
fi
