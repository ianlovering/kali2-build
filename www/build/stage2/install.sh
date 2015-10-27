#!/bin/bash

for module in $(cat modules_common.txt); do
	pushd $module
	chmod 755 ./install.sh
	./install.sh
	popd
done

