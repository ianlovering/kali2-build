#!/bin/bash

TARGET=${1}

for module in $(cat modules_${TARGET}.txt modules_common.txt); do
	pushd $module
	chmod 755 ./install.sh
	./install.sh
	popd
done

