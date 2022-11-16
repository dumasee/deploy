#!/bin/bash
#
#     node_exporter_for_raid.sh @ Version 0.13
#     date: 2022.1.17

  
readonly myHttpServer=192.168.22.9:3080  
  
mkdir -p /opt/deploy
cd /opt/deploy
wget -c $myHttpServer/linux/megacli/megacli.sh

  
crontab -l|grep -Eqi megacli || (crontab -l | (cat;echo "*/1 * * * * mkdir -p /tmp/textcollector && bash /opt/deploy/megacli.sh | sponge /tmp/textcollector/megacli.prom") | crontab -)
