#!/bin/bash

TARGET=$1

sleep 10

sed -i '/\/root\/customise.sh/d' /root/.profile

if [ "x${TARGET}" != "xvm" ]; then
	sed -i 's/AutomaticLogin/# AutomaticLogin/' /etc/gdm3/daemon.conf
fi

mkdir /tmp/custom
cd /tmp/custom
wget -r -nH --cut-dirs=2 -np http://build/deploy/stage2/

chmod 755 install.sh
./install.sh $TARGET
rm /root/customise.sh

MAC=$(ip link | grep ether | awk '{ print $2 }' | sed 's/:/-/g' )
wget http://build/cgi/reset?${MAC}
rm -f reset?${MAC}

shutdown -r now
