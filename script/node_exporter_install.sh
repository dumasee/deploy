#!/bin/bash
#
#     node_exporter_install.sh @ Version 0.19
#     date: 2021.9.28


readonly myHttpServer=192.168.22.9:3080  

cd /opt/
wget -c $myHttpServer/script/exporter_start.sh
wget -c $myHttpServer/linux/prometheus/node_exporter-1.1.1.linux-amd64.tar.gz
tar zxvf node_exporter-1.1.1.linux-amd64.tar.gz
bash exporter_start.sh

