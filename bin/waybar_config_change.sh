#!/bin/bash

# Directory where the config folders are located
CONFIG_DIR="$HOME/.config/waybar/"

# File containing the current config number
CONFIG_NO_FILE="$HOME/.local/bin/waybar/config_no"

# Get the direction from the command line argument
if [[ "$1" == "i" ]]; then
    DIRECTION="next"
elif [[ "$1" == "d" ]]; then
    DIRECTION="prev"
else
    echo "Invalid argument. Usage: waybar_next.sh [i|d]"
    exit 1
fi

# Read the current config number
CURRENT_CONFIG=$(cat "$CONFIG_NO_FILE")

# Get the list of config folders (directories only)
CONFIG_FOLDERS=$(find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type d -name "config*" | sort)

# Get the total number of config folders
TOTAL_CONFIGS=$(echo "$CONFIG_FOLDERS" | wc -l)

# Get the index of the current config
CURRENT_INDEX=$(echo "$CONFIG_FOLDERS" | grep -n "config$CURRENT_CONFIG$" | cut -d: -f1)

# Calculate the index of the next config
if [[ "$DIRECTION" == "next" ]]; then
    NEXT_INDEX=$((CURRENT_INDEX % TOTAL_CONFIGS + 1))
elif [[ "$DIRECTION" == "prev" ]]; then
    NEXT_INDEX=$((CURRENT_INDEX == 1 ? TOTAL_CONFIGS : CURRENT_INDEX - 1))
fi

# Get the next config number
NEXT_CONFIG=$(echo "$CONFIG_FOLDERS" | sed -n "${NEXT_INDEX}p" | sed 's/.*config\([0-9]\+\)$/\1/')

# Write the next config number to the file
echo "config$NEXT_CONFIG" > "$CONFIG_NO_FILE"

# Kill the previous Waybar instance
pkill waybar

# Run launch_waybar.sh
$HOME/.local/bin/launch_waybar.sh

echo "Switched to config$NEXT_CONFIG"

