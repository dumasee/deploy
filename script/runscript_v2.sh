#!/bin/bash
#
#     runscript.sh @ Version 0.23
#     date: 2022.02.27

if [ "$#" -ne 2 ]; then
  echo "$0 [script] [hosts]"
  exit;
fi
echo 'starting....'
echo
user="root"
#pass="Ubuntu123!"
script=$1

for line in `cat $2`
do
  if [ ${line:0:1} == "#" ]; then
    continue;
  fi
  echo "$line"
  ip=$(echo "$line"|awk -F_ '{print $1}')
  port=$(echo "$line"|awk -F_ '{print $2}')
  if [ "$port" == '' ]; then
    port=22
  fi
  
  #copy file
  scp -o ConnectTimeout=3 -o StrictHostKeyChecking=no -P $port $script $user@$ip:/root/  
  
  #run script
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$ip -p $port "cd /root && bash $script"
  
  #delete script
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$ip -p $port "cd /root && rm -rf $script"
  
  echo
done
echo 'finished.'
