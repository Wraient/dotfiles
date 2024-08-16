status_check () {
  status=$(warp-cli status | sed -n 's/.*Status update: \([a-zA-Z]*\).*/\1/p' | sed '/^$/d')
}

status_check

connected="Connected"
disconnected="Disconnected"
connecting="Connecting"

if [ "$status" = "$connected" ]; then
  warp-cli disconnect
  notify-send "Disconnecting warp-cli"
elif [ "$status" = "$connecting" ]; then
  warp-cli disconnect
  notify-send "Disconnected warp-cli"
elif [ "$status" = "$disconnected" ]; then
  warp-cli connect
  notify-send "Connecting warp-cli"
else
  echo "Unknown status:\n$status"
  warp-cli status
fi
