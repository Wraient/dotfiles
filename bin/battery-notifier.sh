#!/bin/bash

# --- Configuration ---
# Set your battery name (find with `ls /sys/class/power_supply/`)
BATTERY="BAT0"

# Set percentage levels
LOW_LEVEL=20
CRITICAL_LEVEL=8
FULL_LEVEL=99 # Some laptops report 100% before they are truly full

# Path to battery files
BATTERY_PATH="/sys/class/power_supply/${BATTERY}"

# --- Script Logic ---
# Use a file to store the last notified state to prevent spamming
STATE_FILE="/tmp/battery_state.log"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "INIT" > "$STATE_FILE"
fi

while true; do
    # Get current battery status and capacity
    STATUS=$(cat "${BATTERY_PATH}/status")
    CAPACITY=$(cat "${BATTERY_PATH}/capacity")

    # Get the last notified state
    LAST_STATE=$(cat "$STATE_FILE")

    # 1. CRITICAL ACTION: Suspend if battery is critical and discharging
    if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$CRITICAL_LEVEL" ]; then
        # Use -i to show a critical notification just before suspending
        notify-send -u critical -i "battery-empty" "CRITICAL: Battery Low (${CAPACITY}%)" "Suspending system in 10 seconds..."
        sleep 10
        systemctl suspend
    fi

    # 2. LOW BATTERY NOTIFICATION: If discharging and below low level
    if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$LOW_LEVEL" ]; then
        if [ "$LAST_STATE" != "LOW" ]; then
            notify-send -u normal -i "battery-caution" "Warning: Battery Low (${CAPACITY}%)" "Please connect AC adapter."
            echo "LOW" > "$STATE_FILE"
        fi
    
    # 3. FULL BATTERY NOTIFICATION: If status is Full or Charging at 100%
    elif [ "$STATUS" = "Full" ] || { [ "$STATUS" = "Charging" ] && [ "$CAPACITY" -ge "$FULL_LEVEL" ]; }; then
        if [ "$LAST_STATE" != "FULL" ]; then
            notify-send -u normal -i "battery-full-charged" "Battery Full (${CAPACITY}%)" "You can disconnect the AC adapter."
            echo "FULL" > "$STATE_FILE"
        fi
    
    # 4. CHARGING NOTIFICATION: If status is Charging and was not previously
    elif [ "$STATUS" = "Charging" ]; then
        if [ "$LAST_STATE" != "CHARGING" ]; then
            notify-send -u low -i "ac-adapter" "Charging Started (${CAPACITY}%)"
            echo "CHARGING" > "$STATE_FILE"
        fi

    # 5. DISCHARGING NOTIFICATION: If status is Discharging and was not previously
    elif [ "$STATUS" = "Discharging" ]; then
        if [ "$LAST_STATE" != "DISCHARGING" ] && [ "$LAST_STATE" != "LOW" ]; then
            notify-send -u low -i "battery" "Power Unplugged (${CAPACITY}%)"
            echo "DISCHARGING" > "$STATE_FILE"
        fi
    fi

    # Wait for 60 seconds before checking again
    sleep 60
done
