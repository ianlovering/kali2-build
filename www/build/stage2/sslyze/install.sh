#!/bin/bash

ZIPBASE=sslyze-0_11-linux64

wget http://build/3rdparty/sslyze/${ZIPBASE}.zip

unzip ${ZIPBASE}.zip
pushd ${ZIPBASE}/sslyze
python setup.py install

ln -s /usr/local/bin/sslyze.py /usr/local/bin/sslyze
