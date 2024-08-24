#!/usr/bin/env bash

#set -e -x

#
if [[ ${XDG_CURRENT_DESKTOP} == "ubuntu:GNOME" || ${XDG_CURRENT_DESKTOP} == "Unity" || "GNOME" ]];then
  array=(
  "https://extensions.gnome.org/extension/6325/control-monitor-brightness-and-volume-with-ddcutil/"
  "https://extensions.gnome.org/extension/19/user-themes/"
  "https://extensions.gnome.org/extension/4228/wireless-hid/"
  "https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/"
  "https://extensions.gnome.org/extension/6278/battery-usage-wattmeter/"
  "https://extensions.gnome.org/extension/258/"
  "https://extensions.gnome.org/extension/1386/notification-counter/"
  "https://extensions.gnome.org/extension/3795/notification-timeout/"
  "https://extensions.gnome.org/extension/4105/notification-banner-position/"
  "https://extensions.gnome.org/extension/4548/tactile/"
  "https://extensions.gnome.org/extension/1460/vitals/"
  "https://extensions.gnome.org/extension/744/hide-activities-button/"
  "https://extensions.gnome.org/extension/4099/no-overview/"
  "https://extensions.gnome.org/extension/307/dash-to-dock"
  "https://extensions.gnome.org/extension/6655/openweather/"
  "https://extensions.gnome.org/extension/988/harddisk-led/"
  "https://extensions.gnome.org/extension/5575/power-profile-switcher/"
  "https://extensions.gnome.org/extension/6242/emoji-copy/"
  "https://extensions.gnome.org/extension/1125/github-notifications/"
  "https://extensions.gnome.org/extension/1484/do-not-disturb-time/"
  "https://extensions.gnome.org/extension/1112/screenshot-tool/"
  "https://extensions.gnome.org/extension/615/appindicator-support/"
  "https://extensions.gnome.org/extension/1674/topiconsfix/"
  )

  for i in "${array[@]}"
  do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    echo "Installing $EXTENSION_ID - $i"
    wget -q -O "${EXTENSION_ID}.zip" "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
      busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
  done
  #sudo apt update
  #sudo apt install -y gnome-tweaks gnome-shell-extension-manager chrome-gnome-shell
fi
