#!/bin/bash

TOOLS_DIR=/root/Tools

mkdir -p ${TOOLS_DIR}
pushd ${TOOLS_DIR}

git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/offensive-security/exploit-database-bin-sploits.git

popd

