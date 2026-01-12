#!/bin/bash

# GPU Temperature script for gaming waybar
# Supports NVIDIA and AMD GPUs

if command -v nvidia-smi &> /dev/null; then
    # NVIDIA GPU
    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

    if [ -n "$temp" ]; then
        if [ "$temp" -ge 85 ]; then
            class="critical"
        elif [ "$temp" -ge 75 ]; then
            class="warning"
        else
            class="normal"
        fi

        echo "{\"text\":\"GPU $temp°C\", \"tooltip\":\"GPU Temperature: $temp°C\", \"class\":\"$class\"}"
        exit 0
    fi
fi

# AMD GPU (fallback)
if [ -d "/sys/class/drm/card0/device/hwmon" ]; then
    for hwmon in /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input; do
        if [ -f "$hwmon" ]; then
            temp=$(cat "$hwmon")
            temp=$((temp / 1000))

            if [ "$temp" -ge 85 ]; then
                class="critical"
            elif [ "$temp" -ge 75 ]; then
                class="warning"
            else
                class="normal"
            fi

            echo "{\"text\":\"GPU $temp°C\", \"tooltip\":\"GPU Temperature: $temp°C\", \"class\":\"$class\"}"
            exit 0
        fi
    done
fi

# No GPU found
echo "{\"text\":\"\", \"tooltip\":\"No GPU detected\", \"class\":\"\"}"
