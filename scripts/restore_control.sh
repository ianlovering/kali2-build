#!/bin/bash

MNT=/mnt
MODULE_PROFILE=${1}

/root/mount_share.sh ${MNT}
${MNT}/build/scripts/run_modules.sh ${MNT} ${MODULE_PROFILE}

# clean up
sed -i '/\/root\/restore_control/d' /root/.profile
sed -i 's/AutomaticLogin/# AutomaticLogin/' /etc/gdm3/daemon.conf

rm /root/restore_control.sh /root/mount_share.sh

shutdown -r now

