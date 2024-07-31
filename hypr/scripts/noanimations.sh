FOCUSMODEOFF=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

if [ $FOCUSMODEOFF = 0 ]; then
  echo animations!
  hyprctl keyword animations:enabled 1
  notify-send "Focus mode deactivated."
  # ags -c /home/wraient/.config/ags/configs/config/config.js
else
  echo noanimations!
  hyprctl keyword animations:enabled 0
  notify-send "Focus mode Activated."
  # pkill ags
fi
