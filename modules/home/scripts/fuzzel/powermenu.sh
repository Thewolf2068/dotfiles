#!/usr/bin/env bash

# Function to ask for confirmation
confirm() {
    local action=$1
    local choice=$(echo -e "No\nYes" | fuzzel --dmenu -p "Confirm $action? " --minimal-lines --no-exit-on-keyboard-focus-loss --width 20)
    [ "$choice" = "Yes" ]
}

# Main Selection
SELECTION=$(echo -e "󰌾 Lock\n󰍃 Logout\n󰜉 Reboot\n󰐥 Shutdown" | fuzzel --dmenu --minimal-lines --hide-prompt --no-exit-on-keyboard-focus-loss --width 14)

case "$SELECTION" in
    "󰌾 Lock")
        /usr/bin/env swaylock ;;
    "󰍃 Logout")
        confirm "Logout" && /usr/bin/env mmsg dispatch quit ;;
    "󰜉 Reboot")
        confirm "Reboot" && /usr/bin/env systemctl reboot ;;
    "󰐥 Shutdown")
        confirm "Shutdown" && /usr/bin/env systemctl poweroff ;;
esac
