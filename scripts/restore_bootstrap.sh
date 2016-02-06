#!/bin/bash

TARGET=laptop

cat > /root/restore_setup.sh << EOF
#!/bin/bash

MNT=/mnt

wget -P /tmp/ http://build/scripts/mount_share.sh
chmod 755 /tmp/mount_share.sh
/tmp/mount_share.sh

pushd \${MNT}/scripts
./restore.sh ${TARGET}
popd

shutdown -r now

EOF

chmod 755 /root/restore_setup.sh
echo "/root/restore_setup.sh" >> /root/.profile
