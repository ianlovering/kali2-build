#!/bin/bash

vmdebootstrap --sudo --lock-root-password --enable-dhcp --configure-apt --log vmdebootstrap.log --squash=cdroot/live/ --log-level debug --customize /root/test-live/hook.sh --distribution testing

