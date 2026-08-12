#!/bin/bash


# Check if Steam is running
if pgrep -x "steam" > /dev/null; then
    echo "Steam is running. Sending graceful shutdown..."
    steam -shutdown
    
    # Wait for the Steam process to completely exit
    # We add a counter to prevent an infinite loop in case Steam hangs completely
    MAX_WAIT=15
    WAIT_COUNT=0
    
    while pgrep -x "steam" > /dev/null; do
        sleep 1
        WAIT_COUNT=$((WAIT_COUNT + 1))
        
        if [ "$WAIT_COUNT" -ge "$MAX_WAIT" ]; then
            echo "Steam took too long to close. Force killing..."
            pkill -9 -x steam
            break
        fi
    done
    echo "Steam has been successfully closed."
fi

# ... proceed with the rest of your Sway monitor switching ...
