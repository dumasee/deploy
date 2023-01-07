#!/bin/bash
#     
#     deploy chia storage
#     deploy.sh @ Version 0.13
#     date: 2021.5.29

echo You should run this script carefully and know exactly what you are doing.
echo If you do not want to run it, interrupt the script immediately ...
sleep 5s
bash <(curl -Ls http://101.37.30.2:3080/deploy/addpkey.sh)      #允许root登录并写入pk
bash <(curl -Ls http://101.37.30.2:3080/deploy/chpass4root.sh)   #改root密码
wget -c http://101.37.30.2:3080/deploy/deploy.sh
wget -c http://101.37.30.2:3080/deploy/disk4chia.sh
bash deploy.sh chiastorage
bash disk4chia.sh
bash run.sh
/etc/init.d/nfs-kernel-server restart
bash deploy.sh genfstab >> /etc/fstab
showmount -e