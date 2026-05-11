#!/usr/bin/env bash
# Toggle blur globally
STATE=$(hyprctl -j getoption decoration:blur:enabled | jq -r '.int')
if [ "$STATE" -eq 1 ]; then
    hyprctl keyword decoration:blur:enabled false
else
    hyprctl keyword decoration:blur:enabled true
fi
