#!/bin/bash

GETTY=/etc/systemd/system/getty@tty1.service.d

mkdir -p ${GETTY}
cp override.conf ${GETTY}

