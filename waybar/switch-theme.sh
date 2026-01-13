#!/bin/bash

# Waybar Theme Switcher with wofi

WAYBAR_DIR="$HOME/.config/waybar"

# Find all style-*.css files and extract the theme name
THEMES=$(find "$WAYBAR_DIR" -maxdepth 1 -name "style-*.css" -printf "%f\n" | sed -e 's/style-//' -e 's/\.css//')

# Use wofi to select a theme
SELECTED_THEME=$(echo "$THEMES" | wofi --dmenu --prompt "Select Theme")

# Exit if no theme is selected
if [ -z "$SELECTED_THEME" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

# Create symlink to the chosen theme
ln -sf "$WAYBAR_DIR/style-$SELECTED_THEME.css" "$WAYBAR_DIR/style.css"

echo "✓ Switched to $SELECTED_THEME theme!"
echo "✓ Restarting waybar..."

# Restart waybar
killall waybar 2>/dev/null
waybar &>/dev/null &

sleep 0.5
echo "✓ Done! Waybar is now using the $SELECTED_THEME theme."
echo ""
