#!/bin/bash

# Get the currently playing song
current_song=$(playerctl -p spotify metadata title)

# If no song is playing, get the last played song
if [ -z "$current_song" ]; then
    current_song=$(playerctl -l | grep spotify | tail -n 1)
    if [ -n "$current_song" ]; then
        current_song=$(playerctl -p "$current_song" metadata title)
    fi
fi

# Get the playback status
status=$(playerctl -p spotify status)

# If a song is playing, get the playback position
if [ "$status" = "Playing" ]; then
    position=$(playerctl -p spotify position)
    position=$(printf "%.0f:%.2d" $((position / 60)) $((position % 60)))
    echo "{\"text\": \"$current_song - $position\", \"class\": \"$status\"}"
else
    echo "{\"text\": \"$current_song\", \"class\": \"$status\"}"
fi


