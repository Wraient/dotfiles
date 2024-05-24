#!/bin/bash

# Get the list of all sinks (output devices)
sinks=$(pactl list short sinks | awk '{print $2}')

# Get the current default sink
current_sink=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Toggle between the first and second sink
for sink in $sinks; do
    if [[ "$sink" != "$current_sink" ]]; then
        pactl set-default-sink "$sink"
        # Move all currently playing streams to the new default sink
        for input in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$input" "$sink"
        done
        break
    fi
done

