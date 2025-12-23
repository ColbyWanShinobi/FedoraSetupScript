#!/usr/bin/env bash

set -e

PACKAGE_NAME="xorg-x11-server-Xwayland"

NOBARA_URL="https://download.copr.fedorainfracloud.org/results/gloriouseggroll/nobara-43/fedora-43-x86_64/"

# Get the Fedora version
FEDORA_VERSION=$(rpm -E %fedora)

# get the version of the current xwayland package
CURRENT_PACKAGE_VERSION=$(rpm -q --qf '%{VERSION}-%{RELEASE}' $PACKAGE_NAME)

# Get the page content and search it for a link to the Xwayland package
NOBARA_PACKAGE_DIR=$(curl -s "$NOBARA_URL" | grep -oP "href='[0-9]+-$PACKAGE_NAME'" | grep -oP "[0-9]+-$PACKAGE_NAME" | head -n 1)
NOBARA_PACKAGE_URL="${NOBARA_URL}${NOBARA_PACKAGE_DIR}/$PACKAGE_NAME-$CURRENT_PACKAGE_VERSION.x86_64.rpm"

echo "Current Xwayland version: $CURRENT_PACKAGE_VERSION"
echo "Nobara Xwayland package URL: $NOBARA_PACKAGE_URL"

# Download the Xwayland package
#curl -LO "$XWAYLAND_PACKAGE_URL"
# Download the file
echo "Downloading file ${NOBARA_PACKAGE_URL} to ${HOME}/Downloads"
curl --location --silent --fail --show-error --output ${HOME}/Downloads/$PACKAGE_NAME-$CURRENT_PACKAGE_VERSION.x86_64.rpm ${NOBARA_PACKAGE_URL}

# Force install the downloaded package by name to avoid dependency issues
sudo dnf reinstall --assumeyes ${HOME}/Downloads/$PACKAGE_NAME-$CURRENT_PACKAGE_VERSION.x86_64.rpm

# Install versionlock plugin if not already installed
echo "Ensuring versionlock plugin is installed..."
sudo dnf install --assumeyes python3-dnf-plugin-versionlock

# Lock the package to prevent updates
echo "Locking $PACKAGE_NAME to prevent future updates..."
sudo dnf versionlock delete $PACKAGE_NAME 2>/dev/null || true
sudo dnf versionlock add $PACKAGE_NAME

echo "Version lock applied successfully. Package will not be updated by dnf update/upgrade."
echo "To unlock later, run: sudo dnf versionlock delete $PACKAGE_NAME"
