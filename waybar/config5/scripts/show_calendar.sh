#!/bin/bash

CONFIG_FILE="$HOME/.config/waybar/config" # Assuming your Waybar config is named 'config'
SPEED_FORMAT_STRING=" {bandwidthDownKiB}kB/s  {bandwidthUpKiB}kB/s"
ICON_FORMAT_STRING="{icon}"

current_format_in_config=$(jq -r '.network."format-wifi"' "$CONFIG_FILE")

if [[ "$current_format_in_config" == "$SPEED_FORMAT_STRING" ]]; then
    new_format="$ICON_FORMAT_STRING"
else
    new_format="$SPEED_FORMAT_STRING"
fi

jq --arg nf "$new_format" '.network."format-wifi" = $nf' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && \
mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

pkill -SIGHUP waybar
