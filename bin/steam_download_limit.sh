#!/bin/bash

# Define variables
IFACE="eth0"  # Replace with your network interface
STEAM_PID=""
DOWNLOAD_LIMIT=700  # Kb/s
SPEED_TEST_URL="https://www.google.com/generate_204"  # Modify if needed

# Get Steam process ID
STEAM_PID=$(pgrep -f Steam)

# Check if Steam is running
if [[ -z "$STEAM_PID" ]]; then
  echo "Steam is not running. Exiting..."
  exit 1
fi

# Get download speed
DOWNLOAD_SPEED=$(wget -qO- $SPEED_TEST_URL 2>&1 | grep '[0-9]*\.[0-9]*' | cut -d '.' -f 1)

# Convert speed to Kb/s (assuming Mbps measurement from speed test)
DOWNLOAD_SPEED=$(echo "$DOWNLOAD_SPEED * 1000" | bc)

# Manage Steam download based on speed
if [[ "$DOWNLOAD_SPEED" -lt "$DOWNLOAD_LIMIT" ]]; then
  echo "Internet speed ($DOWNLOAD_SPEED Kb/s) is below limit ($DOWNLOAD_LIMIT Kb/s). Stopping Steam download..."
  
  # Stop Steam download using tc (mark and queue with no bandwidth)
  tc filter add dev $IFACE prio 1 protocol ip handle flower:steam_filter dst port 8080 flow mark 1 police rate 0kbit burst 0k buffer 0p limit 0 packets
  tc filter add dev $IFACE prio 1 protocol ip handle flower:steam_filter dst port 443 flow mark 1 police rate 0kbit burst 0k buffer 0p limit 0 packets

else
  echo "Internet speed ($DOWNLOAD_SPEED Kb/s) is above limit. Resuming Steam download..."
  
  # Resume Steam download by removing filter rule
  tc filter del dev $IFACE prio 1 protocol ip handle flower:steam_filter dst port 8080 flow mark 1
  tc filter del dev $IFACE prio 1 protocol ip handle flower:steam_filter dst port 443 flow mark 1
fi

