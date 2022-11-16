#!/bin/bash
#
#     miner_backup.sh @ Version 0.45
#     date: 2022.04.18
#     Note: run as eb/lxl


# first,you should run as root: 
# chmod 777 $LOTUS_BACKUP_BASE_PATH_2; mkdir -p /opt/backup_lotus/ && chmod 777 /opt/backup_lotus/
# 其中，$LOTUS_BACKUP_BASE_PATH 的值需要查看runminer.sh脚本里的设置。如果脚本没有设置，则取/etc/profile里边的设置。


# add to crontab as eb:  #郁康为eb2
#  0 2 * * * bash /home/eb/miner_backup.sh > MinerBackup.log 2>&1


LOTUS_BACKUP_BASE_PATH_2=/mnt   #备份路径不一定是/mnt ，看runminer.sh里设置的变量：LOTUS_BACKUP_BASE_PATH
#LOTUS_BACKUP_BASE_PATH_2=$LOTUS_BACKUP_BASE_PATH

readonly dir_backup=/opt/backup_lotus/   
dst=${dir_backup}$(date +%Y%m%d)/

backup_miner(){   
    source  /etc/profile
    [ ! -d $dst ] && mkdir -p $dst

    #备份lotus配置文件
    cd $LOTUS_PATH
    tar zcvf lotus_bak.tar.gz api config.toml keystore token
    mv lotus_bak*.tar.gz $dst

    #备份miner配置文件
    cd $LOTUS_MINER_PATH
    tar zcvf lotusminer_bak.tar.gz api commonConfig.toml config.toml hostsectors.json keystore license sectorsched.json storage.json token
    mv lotusminer_bak*.tar.gz $dst
    
    #备份矿工数据
    cd
    /usr/local/bin/lotus-miner backup $LOTUS_BACKUP_BASE_PATH_2/lotus-miner_back.cbor
    mv $LOTUS_BACKUP_BASE_PATH_2/lotus-miner_back.cbor $dst
    
}

clean_old(){
    flist=$(du -sh $dir_backup/* |awk  '{print $2}' | head -n -3)   #保留最新的3个备份
    for  f in $flist
    do
        rm -rf $f && echo $f deleted.
    done
}
date +%Y%m%d_%H%M%S
echo started...
backup_miner
clean_old
echo finished.

