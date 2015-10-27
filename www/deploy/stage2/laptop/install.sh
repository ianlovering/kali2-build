#!/bin/bash

# prevent suspending on lid close
sed -i 's/#HandleLidSwitch.*$/HandleLidSwitch=lock/' /etc/systemd/logind.conf

# install wifi drivers
apt-get -y install firmware-iwlwifi
