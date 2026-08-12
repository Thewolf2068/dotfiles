#!/usr/bin/env bash

# Base Fuzzel command (no hardcoded width, allowing it to adapt to device names)
FUZZEL_CMD="fuzzel --dmenu --minimal-lines --no-exit-on-keyboard-focus-loss --hide-prompt"

main_menu() {
    SELECTED_OPTION=$(echo -e "Enable Display\nDisable Display" | $FUZZEL_CMD)

    if [[ -z "$SELECTED_OPTION" ]]; then
        exit 0
    elif [[ "$SELECTED_OPTION" == "Enable Display" ]]; then
        enable_display
    else 
        disable_display
    fi
}

enable_display() {
    SELECTED_DISPLAY=$(swaymsg -t get_outputs  | jq -r '.[] | select(.active == false) | "\(.make) \(.model) (\(.name))" ' | $FUZZEL_CMD | sed 's/.*(\(.*\)).*/\1/' )


    if [[ -z "$SELECTED_DISPLAY" ]]; then
        # User pressed ESC, just exit this function quietly
        main_menu
    fi

    swaymsg output "$SELECTED_DISPLAY" enable
}

disable_display() {
    SELECTED_DISPLAY=$(swaymsg -t get_outputs  | jq -r '.[] | select(.active == true) | "\(.make) \(.model) (\(.name))" ' | $FUZZEL_CMD | sed 's/.*(\(.*\)).*/\1/' )

    if [[ -z "$SELECTED_DISPLAY" ]]; then
        main_menu
    fi

    swaymsg output "$SELECTED_DISPLAY" disable
} 

main_menu
