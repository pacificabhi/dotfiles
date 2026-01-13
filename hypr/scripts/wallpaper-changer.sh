#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Hyprpaper configuration file
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

# Get a list of wallpapers
WALLPAPERS=$(ls "$WALLPAPER_DIR")

# Show wallpaper selection menu with rofi
SELECTED_WALLPAPER=$(echo "$WALLPAPERS" | wofi --dmenu -p "Select Wallpaper")

# If a wallpaper is selected
if [ -n "$SELECTED_WALLPAPER" ]; then
    # Full path to the selected wallpaper
    NEW_WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"

    # Preload the new wallpaper
    hyprctl hyprpaper preload "$NEW_WALLPAPER_PATH"

    # Set the new wallpaper for all monitors
    hyprctl hyprpaper wallpaper ",$NEW_WALLPAPER_PATH"

    # Unload unused wallpapers
    hyprctl hyprpaper unload unused

    # Update hyprpaper.conf to make the change persistent
    sed -i "s|\$wallpath =.*|\$wallpath = \$walldir/$SELECTED_WALLPAPER|g" "$HYPRPAPER_CONF"
fi
