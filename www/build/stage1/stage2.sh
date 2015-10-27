#!/bin/bash

#Wait a bit for login to complete
sleep 20

sed -i '/\/root\/stage2.sh/d' /root/.profile
sed -i 's/AutomaticLogin/# AutomaticLogin/' /etc/gdm3/daemon.conf

mkdir /tmp/custom
cd /tmp/custom
wget -r -nH -np --cut-dirs=2 http://build/build/stage2/

chmod 755 install.sh
./install.sh
rm /root/stage2.sh

MAC=$(ip link | grep ether | awk '{ print $2 }' | sed 's/:/-/g' )
wget http://build/cgi/clone?${MAC}
rm -f clone?${MAC}

shutdown -r
