#!/bin/bash

SCRIPT_DIR=/etc/update-all/update-scripts.d

cp update-all /usr/local/sbin
chmod 555 /usr/local/sbin/update-all

if [ ! -d "${SCRIPT_DIR}" ]; then
	mkdir -p "${SCRIPT_DIR}"
fi

cp update-apt ${SCRIPT_DIR}
chmod 555 ${SCRIPT_DIR}/update-apt

