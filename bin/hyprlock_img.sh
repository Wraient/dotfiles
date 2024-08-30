img_path=$(swaylock_random_img)
sed -i "s|path = /home/$USER/Pictures/wall/.*|path = $img_path|" ~/.config/hypr/hyprlock.conf
hyprlock
