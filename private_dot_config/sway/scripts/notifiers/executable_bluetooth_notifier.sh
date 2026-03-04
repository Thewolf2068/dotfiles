#!/usr/bin/env bash

# Listen exclusively to BlueZ device property changes to save CPU
DBUS_RULE="type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.bluez.Device1'"

dbus-monitor --system "$DBUS_RULE" | while read -r line; do
    
    # 1. Catch the DBus path line and extract the MAC address
    # Example path: /org/bluez/hci0/dev_AA_BB_CC_DD_EE_FF
    if [[ "$line" =~ path=/org/bluez/hci[0-9]+/dev_([A-Z0-9_]+) ]]; then
        # Replace underscores with colons to get a valid MAC address
        MAC="${BASH_REMATCH[1]//_/:}"
    fi

    # 2. Watch for the 'Connected' property changing
    if [[ "$line" =~ string\ \"Connected\" ]]; then
        # The very next line in the DBus output contains the true/false value
        read -r val_line
        
        # Query bluetoothctl for the human-readable name
        # Strip away the leading whitespace and "Name: " prefix
        DEVICE_NAME=$(bluetoothctl info "$MAC" | grep "Name:" | sed -e 's/^[ \t]*Name: //')
        
        # Fallback to the MAC address if the device name isn't cached
        [ -z "$DEVICE_NAME" ] && DEVICE_NAME="$MAC"

        # 3. Trigger the notification based on the boolean value
        if [[ "$val_line" =~ boolean\ true ]]; then
            notify-send "Bluetooth" "󰂱 Connected: $DEVICE_NAME"
        elif [[ "$val_line" =~ boolean\ false ]]; then
            notify-send "Bluetooth" "󰂲 Disconnected: $DEVICE_NAME"
        fi
    fi
done
