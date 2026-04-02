#!/bin/bash
# wallpaper-changer.sh — Quick wallpaper picker (applies to all monitors via IPC)
# For per-monitor control, use monitor-menu.sh.

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

mapfile -t files < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -printf '%f\n' | sort)

[[ ${#files[@]} -eq 0 ]] && exit 0

selected=$(printf '%s\n' "${files[@]}" | wofi --dmenu --insensitive --prompt "Select Wallpaper")
[[ -z "$selected" ]] && exit 0

new_path="$WALLPAPER_DIR/$selected"

# Apply to all active monitors via hyprpaper IPC
hyprctl hyprpaper preload "$new_path" &>/dev/null
hyprctl monitors -j | jq -r '.[].name' | while read -r mon; do
    hyprctl hyprpaper wallpaper "$mon,$new_path" &>/dev/null
done

# Update $wallpath in hyprpaper.conf for persistence
sed -i "s|\(\$wallpath\s*=\s*\).*|\1$new_path|" "$HYPRPAPER_CONF"
