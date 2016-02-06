#!/bin/bash

SCRIPTS="build_control.sh mount_share.sh"

echo "gnome-terminal -x /root/build_control.sh" >> /root/.profile
sed -i 's/# *AutomaticLogin/AutomaticLogin/' /etc/gdm3/daemon.conf

cd /root
for s in ${SCRIPTS}; do
	wget http://build/scripts/${s}
	chmod 755 ${s}
done
