#!/bin/bash

OPH_DIR=/opt/ophcrack_tables

mkdir ${OPH_DIR}
pushd ${OPH_DIR}

wget -r -nH -np --cut-dirs=2 http://build/large/ophcrack_tables/
find . -iname "index.html*" -exec rm {} \;

popd

