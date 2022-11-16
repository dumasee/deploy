#!/bin/bash
#
#     copy_from_storage.sh @ Version 0.9
#     date: 2022.4.2

#用途：从源主机批量拷贝文件或目录 至 本机某个目录中。
# 


if [ "$#" -ne 3 ]; then
  echo "$0 [src_file_list] [src_ip] [dst_dir]"
  exit;
fi
echo 'starting....'
echo
user="root"
#pass="Ubuntu123!"
src_ip=$2
dst_dir=$3
mkdir -p $dst_dir

for line in `cat $1`
do
  if [ ${line:0:1} == "#" ]; then
    continue;
  fi
  echo "$line"
  rsync -av --progress -e 'ssh -p 22'  root@$src_ip:$line $dst_dir
  now=$(date +%Y.%m.%d_%H:%M:%S)
  echo $now $src_ip:$line has Copyed to $dst_dir
done
echo 'finished.'
