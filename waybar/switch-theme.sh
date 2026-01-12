#!/bin/bash

# Waybar Theme Switcher
# Usage: ./switch-theme.sh [catppuccin|tokyonight|nord|gruvbox|cyberpunk]

WAYBAR_DIR="$HOME/.config/waybar"

if [ -z "$1" ]; then
    echo "Waybar Theme Switcher"
    echo "====================="
    echo ""
    echo "Available themes:"
    echo "  1. catppuccin  - Soft pastel purples, pinks, and blues"
    echo "  2. tokyonight  - Deep blue/purple with vibrant neon accents"
    echo "  3. nord        - Cool Arctic blues and cyans"
    echo "  4. gruvbox     - Warm retro oranges and yellows"
    echo "  5. cyberpunk   - Neon glow effects with hot pink, cyan, and electric colors"
    echo ""
    echo "Usage: $0 <theme>"
    echo "Example: $0 catppuccin"
    exit 1
fi

THEME="$1"

if [ ! -f "$WAYBAR_DIR/style-$THEME.css" ]; then
    echo "Error: Theme '$THEME' not found!"
    echo "Available themes: catppuccin, tokyonight, nord, gruvbox, cyberpunk"
    exit 1
fi

# Create symlink to the chosen theme
ln -sf "$WAYBAR_DIR/style-$THEME.css" "$WAYBAR_DIR/style.css"

echo "Switched to $THEME theme!"
echo "Restarting waybar..."

# Restart waybar
killall waybar
waybar &

echo "Done! Waybar is now using the $THEME theme."
