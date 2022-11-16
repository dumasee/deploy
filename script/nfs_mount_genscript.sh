#!/bin/bash
#
#     nfs_mount_genscript.sh @ Version 0.15
#     date: 2022.2.26


file=nfs.fstab
script=addNFS.sh
[ ! -f $file ] && echo $file: file not found! && exit 0

#mkdirs
function mkdirs(){
    cat $file |grep nfs | awk '{print "mkdir -p",$2}'
}

#mount
function mountNFS(){
   cat $file |grep nfs | awk '{print "mount -t nfs",$1,$2}'
}

mkdirs > $script
mountNFS >> $script
echo "df -hT|grep nfs" >> $script

echo $script: script generated.

