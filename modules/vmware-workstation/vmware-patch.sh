#!/bin/bash

MODULE_SOURCE=/usr/local/lib/vmware/modules/source

pushd ${MODULE_SOURCE}

rm -f vmmon.tar.orig
tar xf vmmon.tar
mv vmmon.tar vmmon.tar.orig
sed -r -i -e 's/get_user_pages(_remote)*/get_user_pages_remote/g' vmmon-only/linux/hostif.c
tar cf vmmon.tar vmmon-only
rm -r vmmon-only

rm -f vmnet.tar.orig
tar xf vmnet.tar
mv vmnet.tar vmnet.tar.orig
sed -r -i -e 's/get_user_pages(_remote)*/get_user_pages_remote/g' vmnet-only/userif.c
sed -i -e 's/dev->trans_start = jiffies/netif_trans_update\(dev\)/g' vmnet-only/netif.c
tar cf vmnet.tar vmnet-only
rm -r vmnet-only

popd

