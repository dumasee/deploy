#!/bin/bash
#
#     prepare1.sh @ Version 0.17
#     date: 2021.9.4

if [ "$#" -ne 1 ]; then
  echo "$0 [hosts]"
  exit;
fi
echo 'starting....'
echo
user="ubuntu"
pass="Ubuntu123!"

for line in `cat $1`
do
  if [ ${line:0:1} == "#" ]; then
    continue;
  fi
  echo "$line"
  
  #拷贝文件
  sshpass -p $pass scp -o ConnectTimeout=3 -o StrictHostKeyChecking=no addpkey.sh $user@$line:/home/$user/
  
  #添加pubkey
  sshpass -p $pass ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no $user@$line "echo "$pass" | sudo -S bash /home/$user/addpkey.sh"
  echo
done
echo 'finished.'
