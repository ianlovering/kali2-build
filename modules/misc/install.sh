#!/bin/bash

INSTALL=${1}/misc

pushd ${INSTALL}/deb
ls *.deb | xargs -n 1 dpkg -i
popd

pushd bin
for f in $(ls); do 
	cp $f /usr/local/bin
	chmod 555 /usr/local/bin/${f}
done
popd

pushd desktop
cp *.desktop /usr/local/share/applications
popd

mkdir -p /root/.gconf/apps/gksu
cp config/gksu-gconf.xml /root/.gconf/apps/gksu/%gconf.xml

mkdir -p /home/become
