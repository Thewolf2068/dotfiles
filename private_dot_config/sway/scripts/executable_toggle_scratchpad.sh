#!/bin/bash
APP_ID="scratchpad_term"

if swaymsg -t get_tree | grep -q "$APP_ID"; then
    swaymsg "[app_id=\"$APP_ID\"] scratchpad show"
else
    # Let the for_window rule in windowrules.conf do the heavy lifting
    swaymsg "exec kitty --class $APP_ID"
fi
