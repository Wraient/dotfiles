#!/bin/bash

# Get the current player status
status=$(playerctl status 2> /dev/null)

# If a song is playing, display the song info
if [ "$status" = "Playing" ]; then
    artist=$(playerctl metadata artist)
    title=$(playerctl metadata title)
    position=$(playerctl position)
    duration=$(playerctl metadata mpris:length | awk '{print $1 / 1000000}')

    echo " $artist - $title ($position/$duration)"
else
    echo ""
fi

