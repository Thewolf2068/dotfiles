#!/usr/bin/env bash

# Base Fuzzel command (no hardcoded width, allowing it to adapt to device names)
FUZZEL_CMD="fuzzel --dmenu --minimal-lines --no-exit-on-keyboard-focus-loss"

# Function to ask for confirmation
confirm() {
    local action=$1
    local choice=$(echo -e "󰜺 No\n󰄬 Yes" | $FUZZEL_CMD -p "Confirm $action? ")
    [ "$choice" = "󰄬 Yes" ]
}

# Main Menu
main_menu() {
    # Check if bluetooth is powered on
    if bluetoothctl show | grep -q "Powered: yes"; then
        POWER_OP="󰂲 Power Off"
    else
        POWER_OP="󰂯 Power On"
    fi

    CHOICE=$(echo -e "$POWER_OP\n󰂰 Manage Devices\n󰂚 Scan for Devices" | $FUZZEL_CMD --hide-prompt)

    case "$CHOICE" in
        "󰂲 Power Off") bluetoothctl power off ;;
        "󰂯 Power On") bluetoothctl power on ;;
        "󰂰 Manage Devices") manage_devices ;;
        "󰂚 Scan for Devices") scan_devices ;;
    esac
}

# Scan for devices
scan_devices() {
    notify-send "Bluetooth" "Scanning for devices (10s)..."
    bluetoothctl scan on &
    SCAN_PID=$!
    sleep 10
    kill $SCAN_PID
    notify-send "Bluetooth" "Scan complete."
    manage_devices
}

# List devices and select one
manage_devices() {
    # Get list of devices and format them
    DEVICES=$(bluetoothctl devices | sed 's/Device //g')
    
    if [ -z "$DEVICES" ]; then
        echo -e "󰂲 No devices found" | $FUZZEL_CMD --hide-prompt
        exit 0
    fi

    SELECTED_DEVICE=$(echo "$DEVICES" | $FUZZEL_CMD -p "Select Device > ")
    
    # Exit if nothing is selected (e.g., pressed Escape)
    [ -z "$SELECTED_DEVICE" ] && exit 0

    # Extract MAC and Name
    MAC=$(echo "$SELECTED_DEVICE" | awk '{print $1}')
    DEVICE_NAME=$(echo "$SELECTED_DEVICE" | cut -d ' ' -f 2-)

    device_action_menu "$MAC" "$DEVICE_NAME"
}

# Actions for a specific device
device_action_menu() {
    MAC=$1
    NAME=$2

    ACTION=$(echo -e "󰂱 Connect\n󰂲 Disconnect\n󰂦 Pair\n󰒍 Trust\n󰆴 Remove\n󰁍 Back" | $FUZZEL_CMD -p "$NAME > ")

    case "$ACTION" in
        "󰂱 Connect") 
            notify-send "Bluetooth" "Connecting to $NAME..."
            bluetoothctl connect "$MAC" 
            ;;
        "󰂲 Disconnect") 
            bluetoothctl disconnect "$MAC" 
            ;;
        "󰂦 Pair") 
            notify-send "Bluetooth" "Pairing with $NAME..."
            bluetoothctl pair "$MAC" 
            ;;
        "󰒍 Trust") 
            bluetoothctl trust "$MAC"
            notify-send "Bluetooth" "Trusted $NAME"
            ;;
        "󰆴 Remove") 
            confirm "Remove $NAME" && bluetoothctl remove "$MAC" && notify-send "Bluetooth" "Removed $NAME"
            ;;
        "󰁍 Back") 
            manage_devices 
            ;;
    esac
}

# Start the script
main_menu
