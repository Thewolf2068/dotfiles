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
    notify-send "󰂚  Bluetooth" "Scanning for devices (10s)..."
    bluetoothctl scan on &
    SCAN_PID=$!
    sleep 10
    kill $SCAN_PID
    notify-send "󰂯  Bluetooth" "Scan complete."
    manage_devices
}

# List devices and select one
manage_devices() {
    # Get list of currently connected MAC addresses to add checkmarks
    CONNECTED_MACS=$(bluetoothctl devices Connected | awk '{print $2}')

    # Get list of all devices and format them (adds a checkmark if connected)
    DEVICES=$(bluetoothctl devices | sed 's/Device //g' | while read -r mac name; do
        if echo "$CONNECTED_MACS" | grep -q "$mac"; then
            echo "󰄬 $mac $name"
        else
            echo "  $mac $name"
        fi
    done)
    
    if [ -z "$DEVICES" ]; then
        echo -e "󰂲 No devices found" | $FUZZEL_CMD --hide-prompt
        exit 0
    fi

    SELECTED_DEVICE=$(echo "$DEVICES" | $FUZZEL_CMD -p "Select Device > ")
    
    # Exit if nothing is selected (e.g., pressed Escape)
    [ -z "$SELECTED_DEVICE" ] && exit 0

    # Strip the checkmark or empty space prefix before parsing (just like the Wi-Fi script)
    CLEAN_SELECTION=$(echo "$SELECTED_DEVICE" | sed 's/^󰄬 //;s/^  //')

    # Extract MAC and Name
    MAC=$(echo "$CLEAN_SELECTION" | awk '{print $1}')
    DEVICE_NAME=$(echo "$CLEAN_SELECTION" | cut -d ' ' -f 2-)

    device_action_menu "$MAC" "$DEVICE_NAME"
}

# Actions for a specific device
# Actions for a specific device
# Actions for a specific device
device_action_menu() {
    MAC=$1
    NAME=$2

    # Fetch current state of the device
    DEVICE_INFO=$(bluetoothctl info "$MAC")

    # 1. Connection Toggle
    if echo "$DEVICE_INFO" | grep -q "Connected: yes"; then
        CONNECT_OP="󰂲 Disconnect"
    else
        CONNECT_OP="󰂱 Connect"
    fi

    # 2. Pair Option (Hide entirely if already paired)
    if echo "$DEVICE_INFO" | grep -q "Paired: yes"; then
        PAIR_OP=""
    else
        PAIR_OP="󰂦 Pair\n"
    fi

    # 3. Trust Toggle
    if echo "$DEVICE_INFO" | grep -q "Trusted: yes"; then
        TRUST_OP="󰒎 Untrust"
    else
        TRUST_OP="󰒍 Trust"
    fi

    # Build the dynamic menu
    ACTION=$(echo -e "${CONNECT_OP}\n${PAIR_OP}${TRUST_OP}\n󰆴 Remove\n󰁍 Back" | $FUZZEL_CMD -p "$NAME > ")

    case "$ACTION" in
        "󰂱 Connect") 
            notify-send "󰂱  Bluetooth" "Connecting to $NAME..."
            CONNECT_OUT=$(bluetoothctl connect "$MAC" 2>&1)
            if [ $? -eq 0 ]; then
                notify-send "󰄬  Bluetooth" "Successfully connected to $NAME"
            else
                ERR_MSG=$(echo "$CONNECT_OUT" | grep -i "failed" | head -n 1)
                [ -z "$ERR_MSG" ] && ERR_MSG="Connection timed out or unreachable."
                notify-send "󰤮  Bluetooth" "Could not connect to $NAME\n$ERR_MSG"
            fi
            ;;
        "󰂲 Disconnect") 
            notify-send "󰂲  Bluetooth" "Disconnecting from $NAME..."
            bluetoothctl disconnect "$MAC" 
            ;;
        "󰂦 Pair") 
            notify-send "󰂦  Bluetooth" "Pairing with $NAME..."
            PAIR_OUT=$(bluetoothctl pair "$MAC" 2>&1)
            if [ $? -eq 0 ]; then
                notify-send "󰄬  Bluetooth" "Successfully paired with $NAME"
            else
                ERR_MSG=$(echo "$PAIR_OUT" | grep -i "failed" | head -n 1)
                [ -z "$ERR_MSG" ] && ERR_MSG="Pairing rejected or timed out."
                notify-send "󰤮  Bluetooth" "Could not pair with $NAME\n$ERR_MSG"
            fi
            ;;
        "󰒍 Trust") 
            bluetoothctl trust "$MAC"
            notify-send "󰒍  Bluetooth" "Trusted $NAME"
            ;;
        "󰒎 Untrust") 
            bluetoothctl untrust "$MAC"
            notify-send "󰒎  Bluetooth" "Untrusted $NAME"
            ;;
        "󰆴 Remove") 
            confirm "Remove $NAME" && bluetoothctl remove "$MAC" && notify-send "󰆴  Bluetooth" "Removed $NAME"
            ;;
        "󰁍 Back") 
            manage_devices 
            ;;
    esac
}

# Start the script
main_menu
