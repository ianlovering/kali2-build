#!/bin/bash

# Fix grub
mount -t efivars efivars /sys/firmware/efi/efivars
grub-install --force-extra-removable /dev/sda

SCRIPTS="build_control.sh mount_share.sh"

echo "tmux new-session -d -n \"Install Modules\" /root/build_control.sh" >> /root/.profile
sed -i 's/# *AutomaticLogin/AutomaticLogin/' /etc/gdm3/daemon.conf

cd /root
for s in ${SCRIPTS}; do
	wget http://build/scripts/${s}
	chmod 755 ${s}
done

