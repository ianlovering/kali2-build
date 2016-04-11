#!/bin/bash

# Create clone script to run post login

cat > /root/clone.sh << EOF
#!/bin/bash

PART=/dev/sda1
MNT=/mnt

SMB_SHARE=//build/images
SMB_USER=clonewrite
SMB_PASS=clonewrite

IMG_NAME=kali-rolling_\$(date +%Y-%m-%d_%H:%M:%S).gz

mount \$PART \$MNT
pushd \${MNT}/boot/grub
rm grub.cfg
mv grub.cfg.real grub.cfg
rm -rf \${MNT}/boot/live
popd
umount \$MNT 

while ! mount | grep -q "\${MNT}"; do
	sleep 2
	mount -o username=\${SMB_USER},password=\${SMB_PASS} -t cifs \${SMB_SHARE} \${MNT}
done

e2fsck -f -y \${PART}
resize2fs -M \${PART}
partclone.ext4 -c -s \${PART} | gzip > \${MNT}/\${IMG_NAME}

umount \${MNT}

# Wipe partition table so will pxe boot next time?

shutdown now
EOF

chmod 755 /root/clone.sh
echo "/root/clone.sh" >> /root/.profile
