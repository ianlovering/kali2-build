#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/oracle-instantclient/

ORACLE_DIR=instantclient_12_1
INSTALL_DIR=/opt/oracle
LD_CONF=/etc/ld.so.conf.d

ls instantclient-*.zip | xargs -n 1 unzip

mkdir -p ${INSTALL_DIR}
mv ${ORACLE_DIR} ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/${ORACLE_DIR}/libclntsh.so.12.1 ${INSTALL_DIR}/${ORACLE_DIR}/libclntsh.so
ln -s ${INSTALL_DIR}/${ORACLE_DIR}/sqlplus /usr/local/bin/sqlplus

mv oracle.conf ${LD_CONF}
ldconfig
