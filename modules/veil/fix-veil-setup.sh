#!/bin/bash

sed -i 's!"\${rootdir}/setup/python-2\.7\.5\.msi \${arg}"!"\${rootdir}/setup/python-2\.7\.5\.msi" \${arg}!' setup.sh
sed -i 's!"\${rootdir}/setup/rubyinstaller-1\.8\.7-p371\.exe \${arg}"!"\${rootdir}/setup/rubyinstaller-1\.8\.7-p371\.exe" \${arg}!' setup.sh
sed -i 's/pywin32_postinstall.py -install"/pywin32_postinstall.py" -install/' setup.sh
