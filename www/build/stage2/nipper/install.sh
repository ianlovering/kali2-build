#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/nipper/

dpkg --force-all -i nipperstudio-*.deb

