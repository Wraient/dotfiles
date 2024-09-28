#!/bin/bash
# Set some variables
wall_dir="${HOME}/Pictures/wall/"
cacheDir="${HOME}/.cache/jp${theme}"
rofi_command="rofi -dmenu -theme ${HOME}/.config/rofi/wallSelect.rasi -theme-str ${rofi_override}"

# Create cache dir if not exists
if [ ! -d "${cacheDir}" ] ; then
    echo "Creating cache directory at ${cacheDir}"
    mkdir -p "${cacheDir}"
fi

physical_monitor_size=24
monitor_res=$(hyprctl monitors | grep -A2 Monitor | head -n 2 | awk '{print $1}' | grep -oE '^[0-9]+')
dotsperinch=$(echo "scale=2; $monitor_res / $physical_monitor_size" | bc | xargs printf "%.0f")
monitor_res=$(( $monitor_res * $physical_monitor_size / $dotsperinch ))

rofi_override="element-icon{size:${monitor_res}px;border-radius:0px;}"

# Convert images in directory and subdirectories, then save to cache dir
find "$wall_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | while read -r imagen; do
    if [ -f "$imagen" ]; then
        nombre_archivo=$(basename "$imagen")
        echo "Processing image: $imagen"
        if [ ! -f "${cacheDir}/${nombre_archivo}" ] ; then
            echo "Generating thumbnail for $nombre_archivo"
            if ! magick "$imagen" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${nombre_archivo}"; then
                echo "Error: Failed to process image $imagen"
            fi
        else
            echo "Thumbnail already exists for $nombre_archivo"
        fi
    else
        echo "Error: File $imagen does not exist"
    fi
done

# Select a picture with rofi
wall_selection=$(find "$wall_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort | while read -r A ; do
    nombre_archivo=$(basename "$A")
    echo -en "$nombre_archivo\x00icon\x1f${cacheDir}/$nombre_archivo\n"
done | $rofi_command)

# Check if a wallpaper was selected
if [[ -z "$wall_selection" ]]; then
    echo "No wallpaper selected"
    exit 1
fi

# Get the full path of the selected wallpaper
full_wall_path=$(find "$wall_dir" -type f \( -iname "$wall_selection" \))

# Set the wallpaper
if [ -f "$full_wall_path" ]; then
    echo "Setting wallpaper: $full_wall_path"
    swww img "$full_wall_path"
else
    echo "Error: Wallpaper not found at $full_wall_path"
    exit 1
fi

exit 0

