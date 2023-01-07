#!/bin/bash
#
#     prepare2.sh @ Version 0.17
#     date: 2021.9.4

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
  
  #拷貝文件
  scp -o ConnectTimeout=3 -o StrictHostKeyChecking=no deploy.sh $user@$line:/root/
  
  #配置系統
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "bash deploy.sh configos"
  
  #安裝基礎軟件包及工具
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "bash deploy.sh base"
  echo
done
echo 'finished.'
