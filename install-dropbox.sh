#!/usr/bin/env bash

set -euo pipefail
################
APP_NAME=dropbox
APP_COMMAND=dropbox
DL_URL='https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2025.05.20-1.fc42.x86_64.rpm'
PACKAGE_TYPE=rpm
################
# Space delimited list of required command-line utilities to run this script
prereq_list=(curl dnf)

# Check to see if the prereq utilities are installed
for util in "${prereq_list[@]}";do
  if [ ! -x "$(command -v ${util})" ];then
    echo "Missing utility! Please install [${util}] and try again..."
    exit 1
  fi
done

SETUP_PATH=${HOME}/Downloads/${APP_NAME}
PACKAGE_PATH=${SETUP_PATH}/${APP_NAME}.${PACKAGE_TYPE}

# Create setup directory
echo "Creating Setup Directory: ${SETUP_PATH}"
mkdir -p ${SETUP_PATH}

# Check to see if the app is already installed
if [ -x "$(command -v ${APP_COMMAND})" ];then
	echo "Command '${APP_COMMAND}' is already present. Aborting install."
	exit 0
fi

# Download the file
echo "Downloading file ${DL_URL} to ${PACKAGE_PATH}"
curl --location --silent --fail --show-error --output ${PACKAGE_PATH} ${DL_URL}

# Install the package
echo "Installing ${PACKAGE_PATH}"
sudo dnf install -y ${PACKAGE_PATH} libappindicator-gtk3 python3-gpg

# Install versionlock plugin if not already installed
echo "Ensuring versionlock plugin is installed..."
sudo dnf install --assumeyes python3-dnf-plugin-versionlock

# Lock the package to prevent updates
PACKAGE_NAME="nautilus-dropbox"
echo "Locking $PACKAGE_NAME to prevent future updates..."
sudo dnf versionlock delete $PACKAGE_NAME 2>/dev/null || true
sudo dnf versionlock add $PACKAGE_NAME

# Exclude dropbox packages from DNF updates
echo "Excluding dropbox packages from DNF updates..."
sudo mkdir -p /etc/dnf/dnf.conf.d
echo "exclude=dropbox nautilus-dropbox" | sudo tee /etc/dnf/dnf.conf.d/exclude-dropbox.conf > /dev/null

echo "Version lock applied successfully. Package will not be updated by dnf update/upgrade."
echo "Dropbox packages excluded from DNF updates."
echo "To unlock later, run: sudo dnf versionlock delete $PACKAGE_NAME"
echo "To remove exclude, run: sudo rm /etc/dnf/dnf.conf.d/exclude-dropbox.conf"
