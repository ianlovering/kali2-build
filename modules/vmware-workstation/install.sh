#!/bin/bash

WDIR=/tmp/vmware
INSTALL=${1}/vmware-workstation

LICENSE=$(cat ${INSTALL}/license)
BUNDLE=$(ls -rv ${INSTALL}/VMware-Workstation-*.bundle | xargs -n 1 | head -n 1)
VMWARE_CONFIG=/etc/vmware/config

mkdir -p ${WDIR}
pushd ${WDIR}

sh ${BUNDLE} --console --eulas-agreed \
	--set-setting vmware-installer libdir /usr/local/lib \
	--set-setting vmware-installer prefix /usr/local \
	--set-setting vmware-workstation serialNumber ${LICENSE} \
	--required

sed -i 's/dataCollectionEnabled = "yes"/dataCollectionEnabled = "no"/g' ${VMWARE_CONFIG}                                         
sed -i 's/autoSoftwareUpdateEnabled = "yes"/autoSoftwareUpdateEnabled = "no"/g' ${VMWARE_CONFIG}                                         

#disable workstation server
systemctl disable vmware-workstation-server

popd

PREFS_FOLDER=/root/.vmware/
mkdir -p ${PREFS_FOLDER} 
cp preferences ${PREFS_FOLDER}

#/usr/local/bin/vmware-modconfig --console --install-all

