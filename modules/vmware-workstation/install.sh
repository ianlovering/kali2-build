#!/bin/bash

WDIR=/tmp/vmware
INSTALL=${1}/vmware-workstation

LICENSE=$(cat ${INSTALL}/license)
BUNDLE=${INSTALL}/VMware-Workstation-Full-12.1.1-3770994.x86_64.bundle
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

# Build modules
sed -i 's/VMCI_CONFED = "yes"/VMCI_CONFED = "no"/' /etc/vmware/config
/usr/local/bin/vmware-modconfig --console --install-all

