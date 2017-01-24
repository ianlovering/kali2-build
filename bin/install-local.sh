#!/bin/bash

TMP=/tmp/install
TMP_PACKS=${TMP}/packages.txt

INSTALL=/tmp/installer
MODS=${INSTALL}/modules
MOD_LIST=${INSTALL}/etc/modules.txt

THIRD_PARTY=/tmp/3rdparty

HOME=/root

echo "nameserver 8.8.8.8" > /etc/resolv.conf

mkdir -p ${TMP}

for module in $(cat ${MOD_LIST}); do
    MOD_PACKS=${MODS}/${module}/packages.txt    
    if [ -s "${MOD_PACKS}" ]; then  
        cat "${MOD_PACKS}" >> ${TMP_PACKS}
    fi	
done

export DEBIAN_FRONTEND=noninteractive
export DISPLAY=:0

dpkg --add-architecture i386 && apt-get -yq update
apt-get -yq install $( < ${TMP_PACKS})

rm -rf ${TMP}

echo "nameserver 8.8.8.8" > /etc/resolv.conf

for module in $(cat ${MOD_LIST}) temp-boot; do
    echo $module
    if [ -s "${MODS}/${module}/install.sh" ]; then
        echo run  
	    pushd ${MODS}/${module}
	    ./install.sh ${THIRD_PARTY}
	    popd
    fi
done

/usr/local/sbin/update-all
shutdown now

