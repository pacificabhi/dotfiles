#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Hyprpaper configuration file
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

# Get a list of wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f -printf "%f\n")

# Show wallpaper selection menu with rofi
SELECTED_WALLPAPER=$(echo "$WALLPAPERS" | wofi --dmenu -p "Select Wallpaper")

# If a wallpaper is selected
if [ -n "$SELECTED_WALLPAPER" ]; then
    # Full path to the selected wallpaper
    NEW_WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"

    # Update hyprpaper.conf to make the change persistent
    sed -i "s|\$wallpath =.*|\$wallpath = \$walldir/$SELECTED_WALLPAPER|g" "$HYPRPAPER_CONF"

    nohup hyprpaper > /dev/null 2>&1 &
fi
