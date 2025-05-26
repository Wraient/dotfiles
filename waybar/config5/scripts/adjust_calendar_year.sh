#!/bin/bash
STATE_FILE="$HOME/.config/waybar/calendar_state.txt"
ADJUST_TYPE="$1" # "next" or "prev"

# Ensure state file exists
if [ ! -f "$STATE_FILE" ] || ! [ -s "$STATE_FILE" ]; then
    # If user tries to adjust year when no state, initialize to current year
    echo "$(date +%Y)" > "$STATE_FILE"
    exit 0
fi

content=$(cat "$STATE_FILE")

if [[ "$content" =~ ^[0-9]{4}$ ]]; then # If it's a 4-digit year
    year=$((content))
    if [ "$ADJUST_TYPE" == "next" ]; then
        year=$((year + 1))
    elif [ "$ADJUST_TYPE" == "prev" ]; then
        year=$((year - 1))
    else
        exit 1 # Unknown adjustment type
    fi
    echo "$year" > "$STATE_FILE"
else
    # Not in year view (e.g., "month" or malformed).
    # Optionally, switch to current year when trying to adjust:
    # echo "$(date +%Y)" > "$STATE_FILE"
    : # Do nothing if not in year view
fi
# Optional: Add 'pkill -SIGHUP waybar' here for immediate tooltip update (reloads whole bar)
