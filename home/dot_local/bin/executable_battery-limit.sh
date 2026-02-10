#!/bin/bash
set -euo pipefail

# Check if any battery exists
if ! ls /sys/class/power_supply/BAT* >/dev/null 2>&1; then
    # No battery found, exit silently
    exit 0
fi

# Iterate over all found batteries
for BAT_PATH in /sys/class/power_supply/BAT*; do
    # Ensure it's a directory
    [ -d "$BAT_PATH" ] || continue
    
    BAT_NAME=$(basename "$BAT_PATH")
    echo "Configuring battery: $BAT_NAME"

    # Try setting Start Threshold (20%)
    if [ -f "$BAT_PATH/charge_control_start_threshold" ]; then
        echo 20 | sudo tee "$BAT_PATH/charge_control_start_threshold" > /dev/null
    elif [ -f "$BAT_PATH/charge_start_threshold" ]; then
        echo 20 | sudo tee "$BAT_PATH/charge_start_threshold" > /dev/null
    else
        echo "Warning: No start threshold file found for $BAT_NAME"
    fi

    # Try setting End Threshold (80%)
    if [ -f "$BAT_PATH/charge_control_end_threshold" ]; then
        echo 80 | sudo tee "$BAT_PATH/charge_control_end_threshold" > /dev/null
    elif [ -f "$BAT_PATH/charge_stop_threshold" ]; then
        echo 80 | sudo tee "$BAT_PATH/charge_stop_threshold" > /dev/null
    else
        echo "Warning: No end threshold file found for $BAT_NAME"
    fi
done

echo "Battery thresholds set: 20% (start) - 80% (stop)"
