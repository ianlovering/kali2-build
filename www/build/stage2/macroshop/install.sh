#!/bin/bash

pushd /opt
git clone https://github.com/khr0x40sh/MacroShop.git
chmod 755 MacroShop/*.py
popd

ln -s /opt/MacroShop/macro_safe.py /usr/local/bin/macro_safe

mkdir -p /etc/update-all/update-scripts.d
mv macroshop-update /etc/update-all/update-scripts.d/macroshop
chmod 555 /etc/update-all/update-scripts.d/macroshop
