#!/bin/bash
#
#     physical_disk_qeury.sh @ Version 0.13
#     date: 2021.9.2

if [ "$#" -ne 1 ]; then
  echo "$0 [hosts]"
  exit;
fi

echo 'starting....'
echo
user="root"
#pass="Ubuntu123!"

for line in `cat $1`
do
  if [ ${line:0:1} == "#" ]; then
    continue;
  fi
  echo "$line"
  
  #查询硬盘, grep TiB  #for chia/直通模式硬盘
  result1=`ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "fdisk -l|grep -i TiB" `
  echo "$result1"
  
  #查询TiB硬盘数量
  result2=`ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "fdisk -l|grep -i TiB|wc" `
  echo "$result2"
  echo
done
echo 'finished.'
