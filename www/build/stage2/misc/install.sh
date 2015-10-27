#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/misc/

pushd deb
ls *.deb | xargs -n 1 dpkg -i
popd

pushd bin
chmod 555 *
mv * /usr/local/bin
popd

pushd desktop
mv *.desktop /usr/local/share/applications
popd

mkdir -p /root/.gconf/apps/gksu
mv config/gksu-gconf.xml /root/.gconf/apps/gksu/%gconf.xml

tar xf config/wireshark.tar.gz /root/

mkdir -p /home/become
