#!/bin/bash

wget -r -nH -np --cut-dirs=2 http://build/3rdparty/openssl/

tar xf openssl-1.0.1k-linux64.tar.gz -C /usr/local/
tar xf ilssl-1.0.linux-x86_64.tar.gz -C /

