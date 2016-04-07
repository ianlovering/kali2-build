#!/bin/bash

TARGET=laptop

cat > /root/restore_setup.sh << EOF
#!/bin/bash

MNT=/mnt/build

wget -P /tmp/ http://build/scripts/mount_share.sh
chmod 755 /tmp/mount_share.sh
mkdir -p \${MNT}
/tmp/mount_share.sh \${MNT}

pushd \${MNT}/build/scripts
./restore.sh \${MNT} ${TARGET}
popd

#shutdown -r now

EOF

chmod 755 /root/restore_setup.sh
echo "/root/restore_setup.sh" >> /root/.profile
