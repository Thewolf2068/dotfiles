#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
# List the exact names of the monitors you want to toggle here.
# Names must match exactly what appears inside the quotes in 'niri msg outputs'.
MONITORS_TO_TOGGLE=(
    "HKC OVERSEAS LIMITED E2721F 0000000000001"
)
# ==========================================

# 1. Get the current state of all outputs
CURRENT_STATE=$(niri msg outputs)

# 2. Loop through each monitor in the configuration list
for MONITOR in "${MONITORS_TO_TOGGLE[@]}"; do
    echo "Checking monitor: $MONITOR"

    # We grep for the specific line starting with 'Output "Monitor Name"'
    # -F ensures we treat the string literally (ignoring special regex chars)
    # -A 1 grabs the line immediately following the name, which contains the status
    MONITOR_INFO=$(echo "$CURRENT_STATE" | grep -F -A 1 "Output \"$MONITOR\"")

    # Safety check: Did we actually find the monitor in the niri output?
    if [[ -z "$MONITOR_INFO" ]]; then
        echo "  [!] Monitor not found in current outputs. Is it plugged in?"
        continue
    fi

    # 3. Check status and Toggle
    # If the line immediately following the name contains "Disabled", the monitor is off.
    if echo "$MONITOR_INFO" | grep -q "Disabled"; then
        echo "  -> Status: DISABLED. Turning ON..."
        niri msg output "$MONITOR" on
    else
        echo "  -> Status: ENABLED. Turning OFF..."
        niri msg output "$MONITOR" off
    fi

    echo "  -> Done."
    echo "--------------------------------"
done
