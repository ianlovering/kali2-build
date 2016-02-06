#!/bin/bash

ZIPBASE=sslyze-0_11-linux64
ZIP=${1}/sslyze/${ZIPBASE}.zip

pushd /tmp
unzip ${ZIP}
pushd ${ZIPBASE}/sslyze
python setup.py install
popd
popd

ln -s /usr/local/bin/sslyze.py /usr/local/bin/sslyze
