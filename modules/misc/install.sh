#!/bin/bash

INSTALL=${1}/misc

pushd ${INSTALL}/deb
ls *.deb | xargs -n 1 dpkg -i
popd

pushd bin
cp * /usr/local/bin
popd

pushd desktop
cp *.desktop /usr/local/share/applications
popd

mkdir -p /root/.gconf/apps/gksu
cp config/gksu-gconf.xml /root/.gconf/apps/gksu/%gconf.xml

tar xf config/wireshark.tar.gz /root/

mkdir -p /home/become
