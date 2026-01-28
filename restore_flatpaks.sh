#!/bin/bash

# Script to restore Flatpaks from flatpak_list.txt

if [ ! -f "flatpak_list.txt" ]; then
    echo "Error: flatpak_list.txt not found!"
    echo "Please run save_flatpaks.sh first to generate the list."
    exit 1
fi

echo "Reading Flatpak list from flatpak_list.txt..."

# Count total packages
total=$(wc -l < flatpak_list.txt)
echo "Found $total Flatpak(s) to install"
echo ""

# Counter for progress
current=0

# Read each line and install
while IFS= read -r app; do
    # Skip empty lines
    [ -z "$app" ] && continue

    current=$((current + 1))
    echo "[$current/$total] Installing: $app"

    # Install from flathub (assuming flathub is the default remote)
    flatpak install -y flathub "$app"

    if [ $? -eq 0 ]; then
        echo "✓ Successfully installed $app"
    else
        echo "✗ Failed to install $app (may already be installed or not found)"
    fi
    echo ""
done < flatpak_list.txt

echo "Flatpak restoration complete!"
