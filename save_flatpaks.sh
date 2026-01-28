#!/bin/bash

# Script to save list of installed Flatpaks

echo "Saving list of installed Flatpaks..."

# Get list of installed flatpak applications (excluding runtimes)
flatpak list --app --columns=application > flatpak_list.txt

if [ $? -eq 0 ]; then
    count=$(wc -l < flatpak_list.txt)
    echo "Successfully saved $count Flatpak(s) to flatpak_list.txt"
else
    echo "Error: Failed to get Flatpak list"
    exit 1
fi
