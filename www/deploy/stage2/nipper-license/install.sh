#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/nipper-license/

# Nipper License
CONF_DIR=/root/.config/Titania
mkdir -p ${CONF_DIR}
cp LM.conf.new ${CONF_DIR}
cp LM.conf.new ${CONF_DIR}/LM.conf

