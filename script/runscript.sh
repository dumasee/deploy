#!/bin/bash
#
#     runscript.sh @ Version 0.15
#     date: 2021.12.29

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
  
  #copy file
  scp -o ConnectTimeout=3 -o StrictHostKeyChecking=no $script $user@$line:/root/  
  
  #run script
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "cd /root && bash $script"
  
  #delete script
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "cd /root && rm -rf $script"
  
  echo
done
echo 'finished.'
