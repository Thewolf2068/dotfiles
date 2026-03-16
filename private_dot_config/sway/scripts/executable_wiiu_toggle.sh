#!/bin/bash

HEADLESS="HEADLESS-1"
# Check if headless is currently active
HEADLESS_ACTIVE=$(swaymsg -t get_outputs | jq -r ".[] | select(.name == \"$HEADLESS\" and .active == true) | .name")

if [ -z "$HEADLESS_ACTIVE" ]; then
    # --- ENABLE WII U HYBRID MODE ---
    # Wake up the headless monitor (1440p, per your monitors.conf)
    swaymsg output "$HEADLESS" enable
    
    # Optional: Move to a specific workspace on your main monitor for Cemu
    # swaymsg workspace 1
else
    # --- DISABLE WII U HYBRID MODE ---
    # Put the headless monitor back to sleep
    swaymsg output "$HEADLESS" disable
    
    # Reload sway to clean up any leftover window routing
    swaymsg reload
fi
