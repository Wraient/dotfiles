#!/bin/bash

# Track previous window count per workspace
declare -A prev_counts

# Function to get gaps from the current configuration
get_config_gaps() {
    local setting="$1"
    hyprctl getoption "$setting" | grep -oP '(?<=int: )\d+'
}

# Fetch gaps from the current configuration
GAPS_IN=$(get_config_gaps general:gaps_in)
GAPS_OUT=$(get_config_gaps general:gaps_out)

# Infinite loop to check window count periodically
while true; do
    # Get all workspaces and monitors
    monitors=$(hyprctl monitors -j | jq -r '.[].name')

    # Variable to track if any workspace has more than one window
    any_workspace_has_multiple_windows=false

    # Loop through each monitor
    for monitor in $monitors; do
        # Get workspaces on the current monitor
        workspaces=$(hyprctl workspaces -j | jq -r --arg monitor "$monitor" '.[] | select(.monitor == $monitor) | .id')

        # Loop through each workspace on this monitor
        for workspace in $workspaces; do
            # Count windows on the current workspace and monitor
            window_count=$(hyprctl clients -j | jq --arg monitor "$monitor" --argjson workspace "$workspace" \
                '[.[] | select(.monitor == $monitor and .workspace.id == $workspace)] | length')

            # Update the condition if any workspace has more than one window
            if [[ "$window_count" -gt 1 ]]; then
                any_workspace_has_multiple_windows=true
            fi
        done
    done

    # Set gaps based on whether any workspace has more than one window
    if $any_workspace_has_multiple_windows; then
        hyprctl keyword general:gaps_in $GAPS_IN
        hyprctl keyword general:gaps_out $GAPS_OUT
    else
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
    fi

    # Sleep before checking again
    sleep 1
done

