#!/bin/bash

echo "Creating Solaar systemd user service..."

# Stop and disable the old system service if it exists
if [ -f /etc/systemd/system/solaar.service ]; then
    echo "Removing old system service..."
    sudo systemctl stop solaar.service 2>/dev/null || true
    sudo systemctl disable solaar.service 2>/dev/null || true
    sudo rm -f /etc/systemd/system/solaar.service
    sudo systemctl daemon-reload
fi

# Create the user systemd directory if it doesn't exist
USER_SERVICE_DIR="$HOME/.config/systemd/user"
mkdir -p "$USER_SERVICE_DIR"

# Create the systemd service file
SERVICE_FILE="$USER_SERVICE_DIR/solaar.service"

echo "Writing service file to $SERVICE_FILE..."
tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=Solaar Logitech Device Manager
Documentation=https://pwr-solaar.github.io/Solaar/
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/solaar -w hide -b symbolic
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Reload systemd to recognize the new service
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

# Enable the service to start on boot
echo "Enabling Solaar service..."
systemctl --user enable solaar.service

# Start the service now
echo "Starting Solaar service..."
systemctl --user start solaar.service

# Wait a moment for the service to start
sleep 2

# Check if the service is running
echo ""
echo "Checking service status..."
if systemctl --user is-active --quiet solaar.service; then
    echo "✓ Solaar service is running successfully!"
    systemctl --user status solaar.service --no-pager -l
else
    echo "✗ Solaar service failed to start. Checking logs..."
    journalctl --user -u solaar.service -n 20 --no-pager
    exit 1
fi

echo ""
echo "Done! Solaar is now running as a user service."
echo "You can manage it with:"
echo "  systemctl --user status solaar    - Check status"
echo "  systemctl --user restart solaar   - Restart service"
echo "  systemctl --user stop solaar      - Stop service"
