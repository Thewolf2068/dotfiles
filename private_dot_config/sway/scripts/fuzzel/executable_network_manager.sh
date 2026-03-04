#!/usr/bin/env bash

FUZZEL_CMD="fuzzel --dmenu --minimal-lines --no-exit-on-keyboard-focus-loss"

# Main Menu
main_menu() {
    # Check if Wi-Fi is enabled
    WIFI_STATE=$(nmcli -t -f WIFI general)
    if [ "$WIFI_STATE" = "enabled" ]; then
        WIFI_OP="󰤾 Disable Wi-Fi"
    else
        WIFI_OP="󰤨 Enable Wi-Fi"
    fi

    # Grab the active network name to display in the main menu
    ACTIVE_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | head -n 1 | cut -d: -f2)
    
    if [ -n "$ACTIVE_SSID" ]; then
        DISCONNECT_OP="󰌘 Disconnect ($ACTIVE_SSID)"
    else
        DISCONNECT_OP="󰌘 Disconnect Wi-Fi"
    fi

    CHOICE=$(echo -e "$WIFI_OP\n󰤨 Scan & Connect\n$DISCONNECT_OP\n󰦝 Manage VPNs" | $FUZZEL_CMD --hide-prompt)

    case "$CHOICE" in
        "󰤾 Disable Wi-Fi") nmcli radio wifi off ;;
        "󰤨 Enable Wi-Fi") nmcli radio wifi on ;;
        "󰤨 Scan & Connect") scan_and_connect ;;
        "$DISCONNECT_OP") disconnect_active ;;
        "󰦝 Manage VPNs") manage_vpns ;;
    esac
}

# Scan and list networks
scan_and_connect() {
    notify-send "󰤨  Network" "Scanning for Wi-Fi networks..."
    nmcli device wifi rescan > /dev/null 2>&1
    
    # Fetch ACTIVE state, SSIDs, Security, and Signal Bars.
    # We use awk to prepend a checkmark if the network is currently active.
    NETWORKS=$(nmcli -t -f ACTIVE,SSID,SECURITY,BARS device wifi list | grep -v "^:" | awk -F':' '!seen[$2]++ {
        if ($1 == "yes") {
            prefix = "󰄬 "
        } else {
            prefix = "  "
        }
        print prefix $2 " | " $4 " | " $3
    }')
    
    if [ -z "$NETWORKS" ]; then
        echo -e "󰤮 No networks found" | $FUZZEL_CMD --hide-prompt
        exit 0
    fi

    SELECTED=$(echo "$NETWORKS" | $FUZZEL_CMD -p "Select Network > ")
    [ -z "$SELECTED" ] && exit 0

    # Strip the checkmark or empty space prefix before parsing
    CLEAN_SELECTION=$(echo "$SELECTED" | sed 's/^󰄬 //;s/^  //')

    SSID=$(echo "$CLEAN_SELECTION" | awk -F' \\| ' '{print $1}')
    SECURITY=$(echo "$CLEAN_SELECTION" | awk -F' \\| ' '{print $3}')

    connect_to_network "$SSID" "$SECURITY"
}

# Handle Connection and Passwords
connect_to_network() {
    SSID=$1
    SECURITY=$2

    # Check if we already have a saved profile for this exact SSID
    KNOWN_CONNECTION=$(nmcli -t -f NAME connection show | grep -Fx "$SSID")

    if [ -n "$KNOWN_CONNECTION" ]; then
        # The network is already saved, bypass the password prompt
        notify-send "󰤨  Network" "Connecting to saved network $SSID..."
        nmcli connection up id "$SSID"
    else
        # The network is NOT saved, we need to handle it as a new connection
        if [[ "$SECURITY" != *"--" ]] && [[ -n "$SECURITY" ]]; then
            PASSWORD=$(echo "" | fuzzel --dmenu --password -p "Password for $SSID > " --lines 0 --no-exit-on-keyboard-focus-loss)
            [ -z "$PASSWORD" ] && exit 0
            
            notify-send "󰤨  Network" "Connecting to $SSID..."
            nmcli device wifi connect "$SSID" password "$PASSWORD"
        else
            notify-send "󰤨  Network" "Connecting to $SSID..."
            nmcli device wifi connect "$SSID"
        fi
    fi
    
    if [ $? -eq 0 ]; then
        notify-send "󰄬  Network" "Successfully connected to $SSID"
    else
        notify-send "󰤮  Network" "Failed to connect to $SSID"
    fi
}

# Disconnect current Wi-Fi
disconnect_active() {
    # Target only the connected physical interface to avoid iwd ghost devices
    ACTIVE_DEVICE=$(nmcli -t -f DEVICE,TYPE,STATE device | grep 'wifi:connected' | cut -d: -f1 | head -n 1)
    
    if [ -n "$ACTIVE_DEVICE" ]; then
        nmcli device disconnect "$ACTIVE_DEVICE"
        notify-send "󰌘  Network" "Disconnected from Wi-Fi ($ACTIVE_DEVICE)"
    else
        notify-send "󰤮  Network" "No active Wi-Fi connection found"
    fi
}

# VPN Management
manage_vpns() {
    VPNS=$(nmcli -t -f NAME,TYPE connection show | grep -iE 'vpn|wireguard' | cut -d: -f1)

    if [ -z "$VPNS" ]; then
        echo -e "󰦝 No VPNs configured" | $FUZZEL_CMD --hide-prompt
        exit 0
    fi

    SELECTED_VPN=$(echo "$VPNS" | $FUZZEL_CMD -p "Select VPN > ")
    [ -z "$SELECTED_VPN" ] && exit 0

    IS_ACTIVE=$(nmcli -t -f NAME,STATE connection show --active | grep "^$SELECTED_VPN:")

    if [ -n "$IS_ACTIVE" ]; then
        ACTION=$(echo -e "󰌘 Disconnect\n󰁍 Back" | $FUZZEL_CMD -p "$SELECTED_VPN (Active) > ")
        case "$ACTION" in
            "󰌘 Disconnect") 
                nmcli connection down "$SELECTED_VPN"
                notify-send "󰌘  VPN" "Disconnected from $SELECTED_VPN"
                ;;
            "󰁍 Back") manage_vpns ;;
        esac
    else
        ACTION=$(echo -e "󰒍 Connect\n󰁍 Back" | $FUZZEL_CMD -p "$SELECTED_VPN > ")
        case "$ACTION" in
            "󰒍 Connect") 
                notify-send "󰦝  VPN" "Connecting to $SELECTED_VPN..."
                nmcli connection up "$SELECTED_VPN"
                
                if [ $? -eq 0 ]; then
                    notify-send "󰄬  VPN" "Successfully connected to $SELECTED_VPN"
                else
                    notify-send "󰤮  VPN" "Failed to connect to $SELECTED_VPN"
                fi
                ;;
            "󰁍 Back") manage_vpns ;;
        esac
    fi
}

# Start the script
main_menu
