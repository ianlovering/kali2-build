#!/bin/bash

echo "gnome-terminal -x /root/stage2.sh" >> /root/.profile
sed -i 's/# *AutomaticLogin/AutomaticLogin/' /etc/gdm3/daemon.conf

cd /root
wget http://build/build/stage1/stage2.sh
chmod 755 stage2.sh

MAC=$(ip link | grep ether | awk '{ print $2 }' | sed 's/:/-/g' )
wget http://build/cgi/local?${MAC}
rm -f local?${MAC}
