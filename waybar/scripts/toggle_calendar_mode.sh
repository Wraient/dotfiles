#!/bin/bash
STATE_FILE="$HOME/.config/waybar/calendar_state.txt"
CURRENT_YEAR=$(date +%Y)

# Ensure state file exists, initialize to "month" if not
if [ ! -f "$STATE_FILE" ]; then
    echo "month" > "$STATE_FILE"
fi

content=$(cat "$STATE_FILE")

if [[ "$content" == "month" ]]; then
    # Was month, switch to current year
    echo "$CURRENT_YEAR" > "$STATE_FILE"
else
    # Was year (or something else e.g. malformed), switch to month
    echo "month" > "$STATE_FILE"
fi
# Optional: Add 'pkill -SIGHUP waybar' here for immediate tooltip update (reloads whole bar)
