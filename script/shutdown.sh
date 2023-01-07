#!/bin/bash
#
#     shutdown.sh @ Version 0.11
#     date: 2021.11.29

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
  
  #shutdown -h 等于 poweroff
  ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "shutdown -h 1"
  
  echo
done
echo 'finished.'
