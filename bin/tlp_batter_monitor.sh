#!/bin/bash

# Battery levels for notifications
LEVELS=(20 10 5)

#!/bin/bash

# If not running as root, re-run this script with sudo
if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

# Continue with the rest of your script
# Path to store the last notified level
STATE_FILE="/tmp/tlp_last_battery_notification"

# Get current battery percentage from tlp-stat
BATTERY=$(tlp-stat -b | grep -oP 'Battery.*\(\K[0-9]+(?=%)')

# Read the last notified level from the state file
LAST_NOTIFICATION=$(cat "$STATE_FILE" 2>/dev/null)

# Send notification based on battery level
for LEVEL in "${LEVELS[@]}"; do
    if [[ "$BATTERY" -le "$LEVEL" && ( -z "$LAST_NOTIFICATION" || "$LAST_NOTIFICATION" -gt "$BATTERY" ) ]]; then
        notify-send -u critical "Battery Low" "Battery at $BATTERY%. Please charge!"
        echo "$BATTERY" > "$STATE_FILE"
        break
    fi
done

# Clear the state file if the battery is above 20%
if [[ "$BATTERY" -gt 20 ]]; then
    echo "" > "$STATE_FILE"
fi

