#!/bin/bash

echo "Fixing Solaar Flatpak permissions for Logitech devices..."

# Grant Flatpak Solaar access to devices
echo "Granting device access to Solaar Flatpak..."
flatpak override --user io.github.pwr_solaar.solaar --device=all

# Install udev rules if not already done
if [ -f ./etc/udev/rules.d/42-logitech-unify-permissions.rules ]; then
    echo "Installing udev rules..."
    sudo cp ./etc/udev/rules.d/42-logitech-unify-permissions.rules /etc/udev/rules.d/

    # Create plugdev group and add user
    sudo groupadd -f plugdev
    sudo usermod -a -G plugdev ${USER}

    # Reload and trigger udev rules
    echo "Reloading udev rules..."
    sudo udevadm control --reload-rules
    sudo udevadm trigger
else
    echo "Warning: udev rules file not found in ./etc/udev/rules.d/"
fi

# Kill any running Solaar instance to restart it
echo "Stopping Solaar if running..."
flatpak kill io.github.pwr_solaar.solaar 2>/dev/null || true

echo ""
echo "Done! Please:"
echo "  1. Reconnect your Logitech receiver (unplug and plug back in)"
echo "  2. If this is your first time running this script, log out and log back in"
echo "  3. Launch Solaar"
echo ""
echo "Your Logitech devices should now be visible in Solaar."
