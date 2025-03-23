#!/bin/bash

# Set warning levels
WARN_LEVELS=(50 30 10 5 1)
NOTIFIED=()  # Keep track of notified levels

while true; do
    # Get battery percentage
    STATUS=$(acpi -b | awk -F', ' '{print $2}' | tr -d '%')
    CHARGING=$(acpi -b | grep -i "Charging")

    # Check if battery is at a warning level and hasn't been notified
    for LEVEL in "${WARN_LEVELS[@]}"; do
        if [[ "$STATUS" -le "$LEVEL" && ! " ${NOTIFIED[@]} " =~ " $LEVEL " ]]; then
            if [[ -z "$CHARGING" ]]; then
                notify-send "Battery Warning" "Battery at $STATUS%. Plug in the charger!" -u critical
            else
                notify-send "Battery Warning" "Battery at $STATUS%. Still charging!" -u normal
            fi
            NOTIFIED+=("$LEVEL")  # Add to notified list
        fi
    done

    # Reset notifications if battery is fully charged
    if [[ "$STATUS" -ge 100 ]]; then
        NOTIFIED=()
    fi

    sleep 60  # Check every 60 seconds
done

