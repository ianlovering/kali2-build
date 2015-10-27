#!/bin/bash

TARGET=vm

cat > /root/restore_setup.sh << EOF
#!/bin/bash

sleep 20

mkdir -p /tmp/restore
cd /tmp/restore

wget -r -nH -np --cut-dirs=2 http://build/deploy/stage1/
chmod 755 restore_vm.sh
./restore_vm.sh $TARGET

shutdown -r now

EOF

chmod 755 /root/restore_setup.sh
echo "/root/restore_setup.sh" >> /root/.profile
