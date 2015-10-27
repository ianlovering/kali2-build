#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/git-repos/

TOOLS_DIR=/root/Tools
DOCS_DIR=/root/Documents

export GIT_SSL_NO_VERIFY=true

cp expect-git-documents /root
pushd /root
chmod 755 expect-git-documents
./expect-git-documents
rm expect-git-documents
pushd Documents
git config http.sslVerify "false"
popd
popd

mkdir ${TOOLS_DIR}
cp expect-git-tools ${TOOLS_DIR}
pushd ${TOOLS_DIR}

chmod 755 expect-git-tools
./expect-git-tools
rm expect-git-tools
pushd Tools
git config http.sslVerify "false"
popd

git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/offensive-security/exploit-database-bin-sploits.git

popd

