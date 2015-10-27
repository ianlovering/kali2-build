#!/bin/bash

TARGET=vm

cat > /root/clone.sh << EOF
#!/bin/bash

PART=/dev/sda1
MNT=/mnt

SMB_SHARE=//build/images
SMB_USER=clonewrite
SMB_PASS=clonewrite

IMG_NAME=kali2_${TARGET}_\$(date +%Y-%m-%e_%H:%M:%s).gz

while ! mount | grep -q "\${MNT}"; do
	sleep 2
	mount -o username=\${SMB_USER},password=\${SMB_PASS} -t cifs \${SMB_SHARE} \${MNT}
done

e2fsck -f -y \${PART}
resize2fs -M \${PART}
partclone.ext4 -c -s \${PART} | gzip > \${MNT}/\${IMG_NAME}

umount \${MNT}

MAC=\$(ip link | grep ether | awk '{ print \$2 }' | sed 's/:/-/g' )
wget http://build/cgi/reset?\${MAC}
rm -f reset?\${MAC}

shutdown now
EOF

chmod 755 /root/clone.sh
echo "/root/clone.sh" >> /root/.profile
