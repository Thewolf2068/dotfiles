#!/bin/bash
export SWWW_TRANSITION_POS=20,1060
export SWWW_TRANSITION=grow
# Define the wallpapers directory
WALLPAPER_DIR="$HOME/.config/waybar/scripts/Wallpapers"

# Get the current wallpaper file (assuming the current wallpaper is the one set by swww)
CURRENT_WALLPAPER=$(swww query)

# Get all the wallpapers in the directory, sorted alphabetically
WALLPAPERS=($(ls "$WALLPAPER_DIR" | sort))

# Find the index of the current wallpaper in the sorted list
CURRENT_INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$(basename "$CURRENT_WALLPAPER")" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Determine the next wallpaper, cycling back to the start if needed
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Set the next wallpaper
NEXT_WALLPAPER="$WALLPAPER_DIR/${WALLPAPERS[$NEXT_INDEX]}"
swww img "$NEXT_WALLPAPER"