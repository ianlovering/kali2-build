#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/vmware-workstation/

LICENSE=$(cat license)
BUNDLE=VMware-Workstation-Full-11.1.2-2780323.x86_64.bundle
VMWARE_CONFIG=/etc/vmware/config

sh ${BUNDLE} --console --eulas-agreed \
	--set-setting vmware-installer libdir /usr/local/lib \
	--set-setting vmware-installer prefix /usr/local \
	--set-setting vmware-workstation serialNumber ${LICENSE} \
	--required

sed -i 's/dataCollectionEnabled = "yes"/dataCollectionEnabled = "no"/g' ${VMWARE_CONFIG}                                         
sed -i 's/autoSoftwareUpdateEnabled = "yes"/autoSoftwareUpdateEnabled = "no"/g' ${VMWARE_CONFIG}                                         

#disable workstation server
systemctl disable vmware-workstation-server

PREFS_FOLDER=/root/.vmware/
mkdir -p ${PREFS_FOLDER} 
mv preferences ${PREFS_FOLDER}
