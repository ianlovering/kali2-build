#!/bin/bash

MODE=${2}
MNT=${1}
THIRD=${MNT}/3rdparty

pushd ${MNT}/build
for module in $(cat config/${MODE}.modules); do
	pushd modules/$module
	#chmod 755 ./install.sh
	./install.sh ${THIRD}
	popd
done
popd

