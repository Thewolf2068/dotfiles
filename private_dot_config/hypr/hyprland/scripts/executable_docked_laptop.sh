#!/bin/bash

# Set your monitor and config names here
EXTERNAL_MONITOR="DP-2"  # Change to your external monitor name
DOCKED_CONFIG="$HOME/.config/waybar/docked-config-jsonc"
LAPTOP_CONFIG="$HOME/.config/waybar/config.jsonc"

# Function to restart Waybar with the correct config
restart_waybar() {
    killall waybar
    sleep 0.5  # Give it a moment to fully terminate
    if hyprctl monitors | grep -q "$EXTERNAL_MONITOR"; then
        # External monitor is connected
        waybar --config "$DOCKED_CONFIG" &
        hyprctl dispatch workspace 1
        brightnessctl s 100%
    else
        # Only laptop monitor
        waybar --config "$LAPTOP_CONFIG" &
        hyprctl dispatch workspace 1
        brightnessctl s 30%
    fi
}

restart_waybar 

# Listen for Hyprland IPC events
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
while read -r line; do
    if [[ "$line" == monitoradded* ]] || [[ "$line" == monitorremoved* ]]; then
        restart_waybar
    fi
done
