#!/bin/bash

# FPS Counter script for gaming waybar
# Detects FPS from various sources (MangoHud, gamescope, etc.)

# Check for MangoHud log file (if MangoHud is running)
MANGOHUD_LOG="/tmp/mangohud.log"
if [ -f "$MANGOHUD_LOG" ]; then
    fps=$(tail -n 1 "$MANGOHUD_LOG" 2>/dev/null | grep -oP 'FPS: \K[0-9]+' | head -n1)
    if [ -n "$fps" ]; then
        if [ "$fps" -ge 60 ]; then
            class="high"
        elif [ "$fps" -ge 30 ]; then
            class="medium"
        else
            class="low"
        fi
        echo "{\"text\":\"FPS $fps\", \"tooltip\":\"Current FPS: $fps\", \"class\":\"$class\"}"
        exit 0
    fi
fi

# Check for gamescope FPS overlay data
if pgrep -x gamescope > /dev/null; then
    # Gamescope is running, try to get FPS from overlay
    fps=$(cat /tmp/gamescope_fps 2>/dev/null)
    if [ -n "$fps" ]; then
        if [ "$fps" -ge 60 ]; then
            class="high"
        elif [ "$fps" -ge 30 ]; then
            class="medium"
        else
            class="low"
        fi
        echo "{\"text\":\"FPS $fps\", \"tooltip\":\"Current FPS: $fps\", \"class\":\"$class\"}"
        exit 0
    fi
fi

# Check if any game process is running (Steam games)
if pgrep -f "steam.*game" > /dev/null || pgrep -f "\.exe" > /dev/null; then
    echo "{\"text\":\"GAME\", \"tooltip\":\"Game detected\", \"class\":\"gaming\"}"
    exit 0
fi

# No game or FPS data detected
echo "{\"text\":\"\", \"tooltip\":\"No game detected\", \"class\":\"\"}"
