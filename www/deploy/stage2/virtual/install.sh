#!/bin/bash

apt-get -y install open-vm-tools-desktop 

gsettings set org.gnome.settings-daemon.plugins.power active false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

