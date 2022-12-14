#!/bin/bash
#     
#     exporter_start.sh @ Version 0.19
#     date: 2022.2.24

ps -ef|grep node_exporter |grep -qv grep && echo prometheus-node is running. && exit 0
mkdir -p /tmp/textcollector
cd /opt/node_exporter*/ && nohup ./node_exporter --web.listen-address=":9100" --collector.textfile.directory="/tmp/textcollector" > /dev/null 2>&1 &

