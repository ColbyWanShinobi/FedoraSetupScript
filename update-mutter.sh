#!/usr/bin/env bash

set -e

PACKAGE_NAME="mutter"

NOBARA_URL="https://download.copr.fedorainfracloud.org/results/gloriouseggroll/nobara-42/fedora-42-x86_64/"

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
