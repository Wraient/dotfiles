#!/usr/bin/env sh

# Save & restore shader
restore_shader() {
	[ -n "$shader" ] && hyprshade on "$shader"
}
save_shader() {
	shader=$(hyprshade current)
	hyprshade off
	trap restore_shader EXIT
}
save_shader

ScrDir="$(dirname "$(realpath "$0")")"
source "$ScrDir/globalcontrol.sh"

temp_screenshot="/tmp/screenshot.png"

# Helper: print usage
print_error() {
	cat <<EOF
    ./screenshot.sh <action>
    ...valid actions are...
        p   : full screen
        sp  : full screen + swappy
        m   : focused monitor
        sm  : focused monitor + swappy
        s   : select area
        ss  : select area + swappy
        sf  : freeze + select area
        ssf : freeze + select area + swappy
EOF
}

# Screenshot functions (copy only)
full_screenshot() {
	grim - | tee "$temp_screenshot" | wl-copy
}
focused_output() {
	output=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
	grim -o "$output" - | tee "$temp_screenshot" | wl-copy
}
select_area() {
	region=$(slurp)
	[ -n "$region" ] && grim -g "$region" - | tee "$temp_screenshot" | wl-copy
}
select_area_freeze() {
	# No actual freeze in plain grim — placeholder for now
	select_area
}

# Main logic
case $1 in
	p)  full_screenshot ;;
	sp) full_screenshot && swappy -f "$temp_screenshot" ;;
	m)  focused_output ;;
	sm) focused_output && swappy -f "$temp_screenshot" ;;
	s)  select_area ;;
	ss) select_area && swappy -f "$temp_screenshot" ;;
	sf) select_area_freeze ;;
	ssf) select_area_freeze && swappy -f "$temp_screenshot" ;;
	*)  print_error ;;
esac

rm -f "$temp_screenshot"

