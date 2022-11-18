#!/bin/bash

#     
#     lotus_deploy.sh @ Version 0.21
#     date: 2022.04.28

readonly myHttpServer=192.168.22.9:3080
#readonly myHttpServer=183.129.161.12:13080


#lotus-1.16.0-bin_ubuntu2004_amd.tar.gz
#lotus-1.16.0-bin_ubuntu1804_amd.tar.gz
#lotus-1.16.0-bin_ubuntu1804_intel.tar.gz
#lotus-1.17.0 for ubuntu18.04
#lotus-1.17.1 for ubuntu18.04
#lotus-1.18.0 for ubuntu18.04

readonly f=lotus-1.18.0-bin_ubuntu1804_amd.tar.gz
cd /usr/local/bin/
wget -c $myHttpServer/lotus/$f
tar zxvf $f