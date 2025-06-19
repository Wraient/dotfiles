#!/bin/bash

#========================================================================================
# A real-time battery notification and suspension script for Arch Linux.
#
# Sends notifications for:
# - AC Adapter plugged in
# - AC Adapter unplugged
# - Low battery warning
# - Suspends the system at a critical battery level.
#
# Relies on: acpi, libnotify (notify-send), and systemd (for suspend).
#========================================================================================

### CONFIGURATION ###
# Set the battery level thresholds
SUSPEND_THRESHOLD=10   # Suspend when battery is at or below this percentage
WARNING_THRESHOLD=20   # Send a warning when battery is at or below this percentage

# Set the time interval for checking the battery status (in seconds).
# A lower value means more "real-time" but slightly more CPU usage. 5 seconds is a good balance.
CHECK_INTERVAL=5

# Keep track of the last status to avoid spamming notifications.
LAST_STATUS=""
WARNING_SENT=0 # 0 = No, 1 = Yes

# Start the infinite loop
while true; do
    # Get battery status and percentage
    BATTERY_INFO=$(acpi -b)
    STATUS=$(echo "$BATTERY_INFO" | grep -oP '(?<=: ).*?(?=,)') # Extracts "Charging", "Discharging", "Full"
    PERCENTAGE=$(echo "$BATTERY_INFO" | grep -oP '\d+(?=%)')   # Extracts the number from "80%"

    # ------------------ CORE LOGIC ------------------

    if [ "$STATUS" = "Discharging" ]; then
        # ------ RUNNING ON BATTERY ------

        # 1. Critical Action: Suspend the system
        if [ "$PERCENTAGE" -le "$SUSPEND_THRESHOLD" ]; then
            notify-send --urgency=critical "Battery Critically Low" "Suspending in 10 seconds..."
            sleep 10
            # Re-check before suspending, in case user plugged it in during the 10s wait
            RECHECK_STATUS=$(acpi -b | grep -oP '(?<=: ).*?(?=,)')
            if [ "$RECHECK_STATUS" = "Discharging" ]; then
                systemctl suspend
            fi

        # 2. Warning Notification
        elif [ "$PERCENTAGE" -le "$WARNING_THRESHOLD" ] && [ "$WARNING_SENT" -eq 0 ]; then
            notify-send --urgency=normal "Battery Low" "Battery is at ${PERCENTAGE}%. Please connect the AC adapter."
            WARNING_SENT=1 # Mark warning as sent to avoid spam

        # 3. "Unplugged" Notification
        elif [ "$LAST_STATUS" != "Discharging" ]; then
            notify-send --urgency=low "Power Unplugged" "Running on battery at ${PERCENTAGE}%."
        fi

        # Reset warning flag if battery is charged above the threshold
        if [ "$PERCENTAGE" -gt "$WARNING_THRESHOLD" ]; then
            WARNING_SENT=0
        fi

    else
        # ------ PLUGGED IN (Charging or Full) ------

        # 1. "Plugged In" Notification
        if [ "$LAST_STATUS" = "Discharging" ]; then
            notify-send --urgency=low "Power Plugged In" "Battery is now charging at ${PERCENTAGE}%."
        fi
        
        # 2. Reset the warning flag since we're plugged in
        WARNING_SENT=0
    fi

    # Update the last known status
    LAST_STATUS="$STATUS"

    # Wait for the next check
    sleep "$CHECK_INTERVAL"

done
