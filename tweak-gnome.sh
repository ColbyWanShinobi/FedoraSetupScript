#! /bin/bash

# Move Show Apps Button
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

# Use dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Always show thumbnail previews in Nautilus
dconf write /org/gnome/nautilus/preferences/show-image-thumbnails '"always"'

# Enable link creation in Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true

# Allow location in weather applet
dconf write org.gnome.shell.weather automatic-location true

# Enable maximize and minimize buttons and move them to the top left corner
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Change touchpad scroll direction to natural
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Set the number of workspaces to one
gsettings set org.gnome.desktop.wm.preferences num-workspaces 1

# Disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

#gnome-shell --replace &
