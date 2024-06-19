#!/bin/bash
waybar -c $HOME/.config/waybar/$(cat ~/.local/bin/waybar/config_no)/config.jsonc -s $HOME/.config/waybar/$(cat ~/.local/bin/waybar/config_no)/style.css
