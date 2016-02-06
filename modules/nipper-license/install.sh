#!/bin/bash

# Nipper License
pushd ${1}/nipper-license
CONF_DIR=/root/.config/Titania
mkdir -p ${CONF_DIR}
cp LM.conf.new ${CONF_DIR}
cp LM.conf.new ${CONF_DIR}/LM.conf
popd

