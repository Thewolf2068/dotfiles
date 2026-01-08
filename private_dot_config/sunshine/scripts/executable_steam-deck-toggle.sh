#!/bin/bash

# --- CONFIGURATION ---
# Physical monitors (names from 'hyprctl monitors')
PHYSICAL_MONITORS=("DP-2" "HDMI-A-1" "eDP-1")
# Virtual monitor name
VIRTUAL_MON="HEADLESS-2"

function enable_deck_mode {
    # 1. Wake up/Create Virtual Monitor
    # We use "enable" if it exists, otherwise create it.
    if hyprctl monitors all | grep -q "$VIRTUAL_MON"; then
        hyprctl keyword monitor $VIRTUAL_MON, enable
    else
        hyprctl output create headless $VIRTUAL_MON
    fi
    
    # 2. Force Resolution & Position (Right of existing screens)
    hyprctl keyword monitor $VIRTUAL_MON, 1280x800@60, 5120x0, 1
    
    # 3. CRITICAL: Wait for GPU to initialize buffer
    sleep 0.5

    # 4. Move Game Workspace to Virtual Monitor
    hyprctl keyword workspace 12, monitor:$VIRTUAL_MON
    hyprctl dispatch moveworkspacetomonitor 12 $VIRTUAL_MON
    
    # 5. SAFETY: Focus Virtual Monitor & Move Cursor
    # Prevents "mouseMoveUnified" crash by getting cursor off the dying screens
    hyprctl dispatch focusmonitor $VIRTUAL_MON
    hyprctl dispatch movecursor 100 100
    
    # 6. Disable Input Wakeup (So controller doesn't wake screens)
    hyprctl keyword misc:mouse_move_enables_dpms 0
    hyprctl keyword misc:key_press_enables_dpms 0
    
    # 7. Sleep Physical Monitors (DPMS OFF)
    # Safer than 'disable' - prevents "page-flip" crash
    for mon in "${PHYSICAL_MONITORS[@]}"; do
        hyprctl dispatch dpms off $mon
    done
    
    notify-send "Steam Deck Mode" "Streaming Active - Monitors Sleeping"
}

function disable_deck_mode {
    # 1. Wake up physical monitors first
    for mon in "${PHYSICAL_MONITORS[@]}"; do
        hyprctl dispatch dpms on $mon
    done
    
    # 2. Wait for screens to wake
    sleep 1

    # 3. Restore Input Wakeup
    hyprctl keyword misc:mouse_move_enables_dpms 1
    hyprctl keyword misc:key_press_enables_dpms 1
    
    # 4. Move Workspace 12 back to main monitor
    hyprctl keyword workspace 12, monitor:DP-2
    hyprctl dispatch moveworkspacetomonitor 12 DP-2
    
    # 5. Hide Virtual Monitor (Disable, don't remove)
    hyprctl keyword monitor $VIRTUAL_MON, disable
    
    notify-send "Steam Deck Mode" "Disabled - Welcome Back"
}

if [ "$1" == "enable" ]; then
    enable_deck_mode
elif [ "$1" == "disable" ]; then
    disable_deck_mode
fi
