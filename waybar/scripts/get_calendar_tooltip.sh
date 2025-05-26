#!/bin/bash
STATE_FILE="$HOME/.config/waybar/calendar_state.txt"
DEFAULT_VIEW="month" # Fallback if state file is malformed

# Initialize state file to "month" if it doesn't exist or is empty
if [ ! -f "$STATE_FILE" ] || ! [ -s "$STATE_FILE" ]; then
    echo "month" > "$STATE_FILE"
fi

content=$(cat "$STATE_FILE")

if [[ "$content" =~ ^[0-9]{4}$ ]]; then # If it's a 4-digit year
    cal -y "$content"
elif [ "$content" == "month" ]; then
    cal
else # Malformed or unexpected content, default to current month
    echo "month" > "$STATE_FILE" # Correct malformed state
    cal
fi
