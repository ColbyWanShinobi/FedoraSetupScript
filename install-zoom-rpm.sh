#!/usr/bin/env bash

set -euo pipefail
################
APP_NAME=zoom
APP_COMMAND=zoom
DL_URL='https://zoom.us/client/6.7.2.6498/zoom_x86_64.rpm'
GPG_KEY_URL='https://zoom.us/linux/download/pubkey?version=6-3-10'
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
GPG_KEY_PATH=${SETUP_PATH}/zoom_package_signing_key.pub

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

# Download the GPG key
echo "Downloading the GPG Key..."
curl --location --silent --fail --show-error --output ${GPG_KEY_PATH} ${GPG_KEY_URL}

# Install the GPG Key
sudo rpm --import ${GPG_KEY_PATH}

# Install the package
echo "Installing ${PACKAGE_PATH}"
sudo dnf install -y ${PACKAGE_PATH} libappindicator-gtk3 python3-gpg
