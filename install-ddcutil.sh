#!/bin/bash

# Install ddcutil
sudo dnf install -y ddcutil

# Load the i2c-dev module
sudo modprobe i2c-dev

# Copy the udev rules file
sudo cp /usr/share/ddcutil/data/60-ddcutil-i2c.rules /etc/udev/rules.d/

# Uncomment the necessary lines in the udev rules file
sudo sed -i 's/^# SUBSYSTEM=="i2c-dev"/SUBSYSTEM=="i2c-dev"/' /etc/udev/rules.d/60-ddcutil-i2c.rules
sudo sed -i 's/^# KERNEL=="i2c-\[0-9\]\*, GROUP="i2c", MODE="0660"/KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"/' /etc/udev/rules.d/60-ddcutil-i2c.rules

# Create the i2c group if it doesn't exist
sudo groupadd --system i2c || true

# Add the current user to the i2c group
sudo usermod -aG i2c $USER || true

# Ensure the i2c-dev module is loaded on boot
MODULE_CONF="/etc/modules-load.d/i2c.conf"
sudo touch $MODULE_CONF
if ! grep -q "^i2c-dev$" "$MODULE_CONF"; then
  echo "i2c-dev" | sudo tee -a "$MODULE_CONF"
fi

# Reboot the system
#echo "Rebooting the system to apply changes..."
#sudo reboot
