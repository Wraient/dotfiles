#!/bin/bash

CONFIG_FILE="$HOME/.config/waybar/config" # Assuming your Waybar config is named 'config'
# If it's config.jsonc or similar, jq will strip comments. For pure JSON, it's fine.

# Define the two format strings
# Use KiB/s or MiB/s for more human-readable speeds. {bandwidthDownBytesF} is bytes with SI suffix.
# Let's use KiB/s for this example. You can adjust.
SPEED_FORMAT_STRING=" {bandwidthDownKiB}kB/s  {bandwidthUpKiB}kB/s"
ICON_FORMAT_STRING="{icon}" # Waybar will use format-icons for this

# Read the current format-wifi from the config file
current_format_in_config=$(jq -r '.network."format-wifi"' "$CONFIG_FILE")

if [[ "$current_format_in_config" == "$SPEED_FORMAT_STRING" ]]; then
    # Current is speed, switch to icon
    new_format="$ICON_FORMAT_STRING"
else
    # Current is icon (or something else), switch to speed
    new_format="$SPEED_FORMAT_STRING"
fi

# Update the config file
jq --arg nf "$new_format" '.network."format-wifi" = $nf' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && \
mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

# Tell Waybar to reload its configuration
pkill -SIGHUP waybar
