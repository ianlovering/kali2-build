#!/bin/bash

THIRD=${1}/git-repos

TOOLS_DIR=/root/Tools
DOCS_DIR=/root/Documents

export GIT_SSL_NO_VERIFY=true

pushd /root
${THIRD}/expect-git-documents
pushd Documents
git config http.sslVerify "false"
popd
popd

mkdir ${TOOLS_DIR}
pushd ${TOOLS_DIR}
${THIRD}/expect-git-tools
pushd Tools
git config http.sslVerify "false"
popd

git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/offensive-security/exploit-database-bin-sploits.git

popd

