#!/bin/bash

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)

# Try to get CPU power usage from intel-rapl (Intel CPUs)
POWER="N/A"
if [[ -d /sys/class/powercap/intel-rapl:0 ]]; then
    # Read energy in microjoules
    ENERGY_FILE="/sys/class/powercap/intel-rapl:0/energy_uj"
    if [[ -r "$ENERGY_FILE" ]]; then
        ENERGY1=$(cat "$ENERGY_FILE")
        sleep 0.1
        ENERGY2=$(cat "$ENERGY_FILE")
        # Calculate power in watts (energy difference / time)
        POWER=$(awk -v e1="$ENERGY1" -v e2="$ENERGY2" 'BEGIN {printf "%.1f", (e2-e1)/100000}')
    fi
fi

# Fallback: try hwmon for AMD or other systems
if [[ "$POWER" == "N/A" ]]; then
    for hwmon in /sys/class/hwmon/hwmon*/power*_input; do
        if [[ -r "$hwmon" ]] && grep -q "CPU\|Package\|Tctl" "$(dirname "$hwmon")/name" 2>/dev/null; then
            POWER_UW=$(cat "$hwmon")
            POWER=$(awk -v p="$POWER_UW" 'BEGIN {printf "%.1f", p/1000000}')
            break
        fi
    done
fi

# Format CPU usage to integer
CPU_INT=$(printf "%.0f" "$CPU_USAGE")

if [[ "$POWER" == "N/A" ]]; then
    echo "{\"text\":\"${CPU_INT}% \",\"tooltip\":\"CPU Usage: ${CPU_INT}%\nPower: Not available\"}"
else
    echo "{\"text\":\"${CPU_INT}% \",\"tooltip\":\"CPU Usage: ${CPU_INT}%\nPower: ${POWER}W\"}"
fi
