#!/bin/bash

# --- Configuration ---
ICON_SPOTIFY="\uf1bc"   # Spotify logo (default/stopped)
ICON_PLAY="\uf04b"      # Play icon (Font Awesome: fa-play)
ICON_PAUSE="\uf04c"     # Pause icon (Font Awesome: fa-pause)
# Alternatives:
# ICON_PLAY="▶"
# ICON_PAUSE="⏸"

# Define Colors (adjust to your theme if desired)
COLOR_ICON_PLAYING="#1DB954"  # Spotify Green (or your preferred play color)
COLOR_ICON_PAUSED="#FFD166"   # A warm yellow/orange for paused state
COLOR_ICON_STOPPED="#909090"  # A muted grey for stopped or inactive

COLOR_ARTIST="#E0E0E0"        # Light grey for artist name
COLOR_SEPARATOR="#707070"     # Medium grey for the separator
COLOR_TITLE="#FFFFFF"         # White for the song title

MAX_LENGTH_ARTIST=20          # Max characters for artist before truncating
MAX_LENGTH_TITLE=25           # Max characters for title before truncating

# --- Helper Function for Truncation ---
truncate_text() {
    local text="$1"
    local max_len="$2"
    if [ ${#text} -gt "$max_len" ]; then
        printf "%.*s…" "$((max_len-1))" "$text"
    else
        printf "%s" "$text"
    fi
}

# --- Main Logic ---
if ! playerctl --player spotify status > /dev/null 2>&1; then
    echo "" # Spotify not running or not detectable
    exit 0
fi

player_status=$(playerctl --player spotify status 2>/dev/null)
artist_raw=$(playerctl --player spotify metadata artist 2>/dev/null)
title_raw=$(playerctl --player spotify metadata title 2>/dev/null)

artist=$(truncate_text "$artist_raw" $MAX_LENGTH_ARTIST)
title=$(truncate_text "$title_raw" $MAX_LENGTH_TITLE)

output=""
current_icon_color="$COLOR_ICON_STOPPED" # Default icon color
current_display_icon="$ICON_SPOTIFY"     # Default icon

case "$player_status" in
    "Playing")
        current_icon_color="$COLOR_ICON_PLAYING"
        current_display_icon="$ICON_PLAY"
        ;;
    "Paused")
        current_icon_color="$COLOR_ICON_PAUSED"
        current_display_icon="$ICON_PAUSE"
        ;;
    "Stopped")
        current_icon_color="$COLOR_ICON_STOPPED"
        current_display_icon="$ICON_SPOTIFY" # Or a generic music note like  (\uf001)
        # If no metadata when stopped, just show the icon
        if [ -z "$artist" ] && [ -z "$title" ]; then
            echo "<span foreground='${current_icon_color}'>${current_display_icon}</span>"
            exit 0
        fi
        ;;
    *) # Covers any other unexpected states, default to stopped appearance
        current_icon_color="$COLOR_ICON_STOPPED"
        current_display_icon="$ICON_SPOTIFY"
        # If no metadata, just show the icon
        if [ -z "$artist" ] && [ -z "$title" ]; then
            echo "<span foreground='${current_icon_color}'>${current_display_icon}</span>"
            exit 0
        fi
        ;;
esac

# Construct the Pango markup string
if [ -n "$artist" ] && [ -n "$title" ]; then
    output="<span foreground='${current_icon_color}'>${current_display_icon}</span> <span foreground='${COLOR_ARTIST}'>${artist}</span> <span foreground='${COLOR_SEPARATOR}'>-</span> <span foreground='${COLOR_TITLE}'>${title}</span>"
elif [ -n "$artist" ]; then
    output="<span foreground='${current_icon_color}'>${current_display_icon}</span> <span foreground='${COLOR_ARTIST}'>${artist}</span>"
elif [ -n "$title" ]; then
    output="<span foreground='${current_icon_color}'>${current_display_icon}</span> <span foreground='${COLOR_TITLE}'>${title}</span>"
elif [ "$player_status" == "Playing" ] || [ "$player_status" == "Paused" ]; then
    # Player is active but no metadata (e.g., an ad, or just started)
    output="<span foreground='${current_icon_color}'>${current_display_icon}</span> <span foreground='${COLOR_TITLE}'>${player_status}...</span>"
else
    # Fallback: Just the icon if stopped/unexpected and no metadata
    output="<span foreground='${current_icon_color}'>${current_display_icon}</span>"
fi

echo "$output"
