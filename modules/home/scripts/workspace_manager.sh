#!/usr/bin/env bash
TARGET=$1
CURRENT_OUTPUT=$(i3-msg -t get_outputs | jq -r '.[] | select(.focused) | .name')
# Only move if the workspace isn't already on the focused monitor
WORKSPACE_OUTPUT=$(i3-msg -t get_workspaces | jq -r ".[] | select(.name == \"$TARGET\") | .output")

if [ "$WORKSPACE_OUTPUT" != "$CURRENT_OUTPUT" ]; then
    i3-msg "workspace $TARGET; move workspace to output $CURRENT_OUTPUT"
fi
i3-msg "workspace $TARGET"
