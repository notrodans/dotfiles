#!/bin/bash
set -euo pipefail

# Check if any battery exists
if ! ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
    # No battery found, exit silently
    exit 0
fi

# Determine toggle state based on first battery
FIRST_BAT=$(ls -d /sys/class/power_supply/BAT* | head -n 1)
CURRENT_STOP=0
if [ -f "$FIRST_BAT/charge_control_end_threshold" ]; then
    CURRENT_STOP=$(cat "$FIRST_BAT/charge_control_end_threshold")
elif [ -f "$FIRST_BAT/charge_stop_threshold" ]; then
    CURRENT_STOP=$(cat "$FIRST_BAT/charge_stop_threshold")
fi

if [ "$CURRENT_STOP" -eq 80 ]; then
    TARGET_START=0
    TARGET_STOP=100
    STATUS="DISABLED (Full charge: 0-100%)"
else
    TARGET_START=20
    TARGET_STOP=80
    STATUS="ENABLED (Conservation: 20-80%)"
fi

echo "Battery limit $STATUS"

# Iterate over all found batteries
for BAT_PATH in /sys/class/power_supply/BAT*; do
    # Ensure it's a directory
    [ -d "$BAT_PATH" ] || continue
    
    BAT_NAME=$(basename "$BAT_PATH")
    echo "Configuring battery: $BAT_NAME"

    # Start Threshold
    if [ -f "$BAT_PATH/charge_control_start_threshold" ]; then
        echo "$TARGET_START" | sudo tee "$BAT_PATH/charge_control_start_threshold" > /dev/null
    elif [ -f "$BAT_PATH/charge_start_threshold" ]; then
        echo "$TARGET_START" | sudo tee "$BAT_PATH/charge_start_threshold" > /dev/null
    fi

    # End Threshold
    if [ -f "$BAT_PATH/charge_control_end_threshold" ]; then
        echo "$TARGET_STOP" | sudo tee "$BAT_PATH/charge_control_end_threshold" > /dev/null
    elif [ -f "$BAT_PATH/charge_stop_threshold" ]; then
        echo "$TARGET_STOP" | sudo tee "$BAT_PATH/charge_stop_threshold" > /dev/null
    fi
done
