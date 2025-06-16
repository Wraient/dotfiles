#!/bin/bash

# --- Configuration ---
BATTERY="BAT0" # CHANGE THIS if your battery is not BAT0
LOW_LEVEL=20
CRITICAL_LEVEL=8
FULL_LEVEL=99

# Name for the notifications and file to store the active notification ID
APP_NAME="Battery Monitor"
NOTIFICATION_ID_FILE="/tmp/battery_notification_id"

# --- Environment Setup for Notifications ---
export USER=$(whoami)
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# --- Script Logic ---
BATTERY_PATH="/sys/class/power_supply/${BATTERY}"
STATE_FILE="/tmp/battery_state.log"

if [ ! -d "$BATTERY_PATH" ]; then
    exit 0
fi

if [ ! -f "$STATE_FILE" ]; then
    echo "INIT" > "$STATE_FILE"
fi

STATUS=$(cat "${BATTERY_PATH}/status")
CAPACITY=$(cat "${BATTERY_PATH}/capacity")
LAST_STATE=$(cat "$STATE_FILE")

# --- Function to send a replaceable notification ---
send_notification() {
    local urgency=$1
    local icon=$2
    local title=$3
    local message=$4
    
    # Read the ID of the last notification
    local replaces_id=""
    if [ -f "$NOTIFICATION_ID_FILE" ]; then
        replaces_id=$(cat "$NOTIFICATION_ID_FILE")
    fi

    # Send the new notification and capture its ID
    # -a: sets the app name
    # -r: replaces the notification with this ID
    # --print-id: prints the new notification's ID to stdout
    local new_id=$(notify-send --app-name="$APP_NAME" \
                               --replaces-id="$replaces_id" \
                               --print-id \
                               -u "$urgency" \
                               -i "$icon" \
                               "$title" \
                               "$message")
    
    # Save the new ID for the next time
    echo "$new_id" > "$NOTIFICATION_ID_FILE"
}

# 1. CRITICAL ACTION: Suspend if battery is critical and discharging
if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$CRITICAL_LEVEL" ]; then
    send_notification "critical" "battery-empty" "CRITICAL: Battery Low (${CAPACITY}%)" "Suspending system in 10 seconds..."
    sleep 10
    systemctl suspend
    exit 0 # Exit after suspend command
fi

# 2. LOW BATTERY NOTIFICATION
if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$LOW_LEVEL" ]; then
    if [ "$LAST_STATE" != "LOW" ]; then
        send_notification "normal" "battery-caution" "Warning: Battery Low (${CAPACITY}%)" "Please connect AC adapter."
        echo "LOW" > "$STATE_FILE"
    fi

# 3. FULL BATTERY NOTIFICATION
elif [ "$STATUS" = "Full" ] || { [ "$STATUS" = "Charging" ] && [ "$CAPACITY" -ge "$FULL_LEVEL" ]; }; then
    if [ "$LAST_STATE" != "FULL" ]; then
        send_notification "normal" "battery-full-charged" "Battery Full (${CAPACITY}%)" "You can disconnect the AC adapter."
        echo "FULL" > "$STATE_FILE"
    fi

# 4. CHARGING NOTIFICATION
elif [ "$STATUS" = "Charging" ]; then
    if [ "$LAST_STATE" != "CHARGING" ]; then
        send_notification "low" "ac-adapter" "Charging Started (${CAPACITY}%)" ""
        echo "CHARGING" > "$STATE_FILE"
    fi

# 5. DISCHARGING NOTIFICATION
elif [ "$STATUS" = "Discharging" ]; then
    if [ "$LAST_STATE" != "DISCHARGING" ] && [ "$LAST_STATE" != "LOW" ]; then
        send_notification "low" "battery" "Power Unplugged (${CAPACITY}%)" ""
        echo "DISCHARGING" > "$STATE_FILE"
    fi
fi
