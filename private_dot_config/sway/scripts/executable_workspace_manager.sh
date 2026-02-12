#!/bin/bash
TARGET=$1
CURRENT_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
# Only move if the workspace isn't already on the focused monitor
WORKSPACE_OUTPUT=$(swaymsg -t get_workspaces | jq -r ".[] | select(.name == \"$TARGET\") | .output")

if [ "$WORKSPACE_OUTPUT" != "$CURRENT_OUTPUT" ]; then
    swaymsg "workspace $TARGET; move workspace to output $CURRENT_OUTPUT"
fi
swaymsg "workspace $TARGET"
