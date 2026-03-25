#!/bin/env bash

# 1. Gather data about the currently focused window
WINDOW_DATA=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | {pid: .pid, app_id: (.app_id // .window_properties.class)}')
PID=$(echo "$WINDOW_DATA" | jq -r '.pid')
APP_ID=$(echo "$WINDOW_DATA" | jq -r '.app_id')

# Exit if no window is focused or PID is null
if [ -z "$PID" ] || [ "$PID" == "null" ]; then
    exit 0
fi

# Tier 1: Polite Wayland Close
swaymsg kill

# Wait up to 2 seconds to see if the window closes cleanly
for i in {1..10}; do
    if ! kill -0 "$PID" 2>/dev/null; then
        # Process has successfully exited
        break
    fi
    sleep 0.2
done

# Tier 2: The process is frozen or ignoring the Wayland close request
if kill -0 "$PID" 2>/dev/null; then
    # Send SIGTERM (15) to gracefully terminate the process and its direct children
    pkill -TERM -P "$PID" 2>/dev/null
    kill -TERM "$PID" 2>/dev/null
    
    # Wait 1 second for it to pack its bags
    sleep 1
    
    # Tier 3: The process is completely locked up. Nuke it.
    if kill -0 "$PID" 2>/dev/null; then
        pkill -KILL -P "$PID" 2>/dev/null
        kill -KILL "$PID" 2>/dev/null
    fi
fi

# ---------------------------------------------------------
# Edge Case Cleanup Phase
# ---------------------------------------------------------

# Gamescope's reaper detaches from the process tree, so it escapes the PID checks above.
# We explicitly check if the app we just closed was gamescope, and hunt the reaper down.
if [ "$APP_ID" == "gamescope" ]; then
    # Try gracefully terminating the reaper first
    killall -TERM gamescopereaper 2>/dev/null
    sleep 1
    # Force kill if it's still stuck looping
    killall -KILL gamescopereaper 2>/dev/null
fi

# You can add future edge cases here easily!
# if [ "$APP_ID" == "some_future_stubborn_app" ]; then
#     killall -TERM its_annoying_daemon
# fi
