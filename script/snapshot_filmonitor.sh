#!/bin/bash
#     
#     
#     snapshot_ipfs.sh @ Version 1.43
#     date: 2022.05.19


readonly url=http://x.x.x.x:13000/filmonitor

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PATH
source /etc/profile

account=$(lotus-miner info --hide-sectors-info|grep Miner:|awk '{print $2}')
ip=$(ip add|grep global|egrep "bond|eth|en" |awk '{print $2}' | awk -F/ '{print $1}'|head -n 1)

daemonNum=$(ps -ef|grep 'lotus daemon'|grep -v grep|wc -l)
minerNum=$(ps -ef|grep 'lotus-miner'|grep -v grep|wc -l)
faultSectorNum=$(lotus-miner proving faults|grep -v Miner|grep -v deadline|wc -l)
today=$(date +'%Y-%m-%d %H:%M:%S')


logpath=/home/eb/lotus-amd-eb/log   #ipfs2-2231 ipfs3-2331 ipfs4北京2-2431 ipfs6-2631 ipfs7-2731 ipfs成都 ipfs4王磊杭州-2432

if [ "$account" == 'f0500685' ]; then
  logpath=/home/eb2/lotus-amd-eb/log   #ipfs5郁康-2132
fi

if [ "$account" == 'f01043666' ]; then
  logpath=/home/lxl/lotus-amd-eb/log   #21.31
fi

logsize_daemon="$(ls -lht $logpath/daemon.log|awk '{print $5}')"
logsize_miner=$(ls -lht $logpath/miner.log|awk '{print $5}')

disk_usage=$(echo $(df -hT|egrep 'xfs|ext'|egrep  -v ' /boot' |awk '{print $6,$7}'))
#disk_usage="24% / 31% /mnt/nvme2 42% /mnt/nvme1"    #format sample

cd $LOTUS_PATH/../ && lotuspath_mountpoint=$(pwd)
disk_usage_lotus=$(echo $(df -hT|egrep 'xfs|ext'|egrep  -v ' /boot'|grep $lotuspath_mountpoint |awk '{print $6,$7}'))
cd


nfs_ip=$(echo $(df -hT|grep nfs4 |awk -F: '{print $1}'| sort -u))
nfs_number=$(echo $(df -hT|grep nfs4 |awk -F: '{print $1}'| sort -u|wc -l))
power=$(echo $(lotus-miner info --hide-sectors-info|grep Power|awk -F: '{print $2}'|awk -F/ '{print $1}'))

cd $logpath
delay=$(echo "scale=4;$(grep "completed mineOne" miner.log*|grep -v '"nullRounds": 0'|wc -l)/$(grep "completed mineOne" miner.log*|wc -l)"|bc)

curl -Ls $url -X POST -H "Content-Type: application/json" \
    -d '{ "account": "'$account'", 
    "ip": "'$ip'", 
    "daemon_log": "'$logsize_daemon'", 
    "miner_log": "'$logsize_miner'", 
    "daemon": "'$daemonNum'", 
    "miner": "'$minerNum'", 
    "disk_usage": "'"$disk_usage"'", 
    "disk_usage_lotus": "'"$disk_usage_lotus"'", 
    "nfs_ip": "'"$nfs_ip"'", 
    "nfs_number": "'"$nfs_number"'", 
    "power": "'"$power"'", 
    "delay": "'"$delay"'", 
    "faults": "'$faultSectorNum'"}'
