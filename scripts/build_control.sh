#!/bin/bash

MNT=/mnt

/root/mount_share.sh ${MNT}
${MNT}/build/scripts/run_modules.sh ${MNT} build

# clean up
sed -i '/\/root\/build_control/d' /root/.profile
sed -i 's/AutomaticLogin/# AutomaticLogin/' /etc/gdm3/daemon.conf

rm /root/build_control.sh /root/mount_share.sh

# Reboot to live
cp -r /mnt/live /boot
cd /boot/grub
mv grub.cfg grub.cfg.real
cp /mnt/build/config/grub.cfg.clone grub.cfg

shutdown -r now

