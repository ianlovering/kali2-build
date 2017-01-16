#!/bin/bash

INSTALL=${1}/chrome

apt-get -yq install libappindicator1
dpkg -i ${INSTALL}/google-chrome-stable_current_amd64.deb

adduser --quiet --gecos "" --disabled-password chrome
cp /usr/share/applications/google-chrome.desktop /root/.local/share/applications/google-chrome.desktop
sed -i 's/Exec=/Exec=gksu -u chrome -l /' /root/.local/share/applications/google-chrome.desktop
