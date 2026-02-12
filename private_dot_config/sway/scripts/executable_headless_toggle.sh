#!/bin/bash

HEADLESS="HEADLESS-1"
# 1. Check if Headless is currently the ONLY active output
# (We check if any output that isn't HEADLESS is active)
PHYSICAL_ACTIVE=$(swaymsg -t get_outputs | jq -r ".[] | select(.name != \"$HEADLESS\" and .active == true) | .name")

if [ -n "$PHYSICAL_ACTIVE" ]; then
    # --- SWITCH TO HEADLESS MODE ---
    # Enable headless first (Sway needs at least one output active)
    # Disable every physical monitor found
    swaymsg output "HEADLESS-1" enable
    for mon in $PHYSICAL_ACTIVE; do
        swaymsg output "$mon" disable
    done
    
    # Move to your streaming workspace
    swaymsg workspace 99
else
    # --- SWITCH TO PHYSICAL MODE ---
    # Find all monitors that are NOT headless and enable them
    # Note: We use 'all' because 'disable' removes them from the active list
    swaymsg output "*" enable

    swaymsg output "HEADLESS-1" disable
    # Return to your main workspace
    pkill waybar
    waybar & 
fi
