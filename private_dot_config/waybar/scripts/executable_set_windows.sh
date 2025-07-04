#!/bin/bash

fastfetch

# Set the next boot entry to 0000
echo "Setting next boot entry to 0000 using efibootmgr..."
sudo efibootmgr -n 0000

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Boot entry successfully set."
else
    echo "Failed to set boot entry. Exiting."
    exit 1
fi

# Prompt the user for restart
read -p "Do you want to restart now? (Y/N): " choice

case "$choice" in
    [Yy]* )
        echo "Rebooting now..."
        sudo reboot
        ;;
    [Nn]* )
        echo "Reboot canceled. You can reboot later manually."
        ;;
    * )
        echo "Invalid input. Please enter Y or N."
        ;;
esac
