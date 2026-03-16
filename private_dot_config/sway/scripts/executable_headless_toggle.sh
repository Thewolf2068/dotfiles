#!/bin/bash

HEADLESS="HEADLESS-1"
PHYSICAL_ACTIVE=$(swaymsg -t get_outputs | jq -r ".[] | select(.name != \"$HEADLESS\" and .active == true) | .name")

if [ -n "$PHYSICAL_ACTIVE" ]; then
    swaymsg output "HEADLESS-1" enable
    for mon in $PHYSICAL_ACTIVE; do
        swaymsg output "$mon" disable
    done
    swaymsg workspace 99
else
    swaymsg output "*" enable
    swaymsg output "HEADLESS-1" disable
    # pkill waybar
    # waybar & 
    swaymsg workspace "99"
    # swaymsg move workspace to output '"LG Electronics LG ULTRAGEAR 407NTVS68263"'
fi
