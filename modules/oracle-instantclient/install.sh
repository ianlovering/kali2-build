#!/bin/bash

INSTALL=${1}/oracle-instantclient

ORACLE_DIR=instantclient_12_1
INSTALL_DIR=/opt/oracle
LD_CONF=/etc/ld.so.conf.d

mkdir -p ${INSTALL_DIR}
pushd ${INSTALL_DIR}
ls ${INSTALL}/instantclient-*.zip | xargs -n 1 unzip
popd

ln -s ${INSTALL_DIR}/${ORACLE_DIR}/libclntsh.so.12.1 ${INSTALL_DIR}/${ORACLE_DIR}/libclntsh.so
ln -s ${INSTALL_DIR}/${ORACLE_DIR}/sqlplus /usr/local/bin/sqlplus

cp oracle.conf ${LD_CONF}
ldconfig
