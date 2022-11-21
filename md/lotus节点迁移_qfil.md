<!-- 更新日期：2022.11.07 -->

## 自建 miner迁移
- 说明
新的miner节点已提前完成部署，lotus daemon进程已正常，已完成同步。

- 源miner（机器1）
192.168.26.31

- 目标miner（机器2）
192.168.26.83

## 机器1 备份数据
1. 备份lotus配置文件
```
su - eb
cd $LOTUS_PATH
tar zcvf lotus_bak.tar.gz api config.toml keystore token
mv lotus*.tar.gz /mnt
```
备份目录：/opt/backup_lotus/


2. 备份miner配置文件
```
su - eb
cd $LOTUS_MINER_PATH
tar zcvf lotusminer_bak.tar.gz api commonConfig.toml config.toml hostsectors.json keystore license sectorsched.json storage.json token
mv lotusminer*.tar.gz /mnt
```
备份目录：  /opt/backup_lotus/


3. 备份矿工数据
导出的路径一定要和runminer.sh里边的变量一致。
```
su - eb
cd lotus-amd-eb/scripts/
grep LOTUS_BACKUP_BASE_PATH runminer.sh 
```

输出：
```
eb@miner2431:~/lotus-amd-eb/script$ grep LOTUS_BACKUP_BASE_PATH runminer.sh 
export LOTUS_BACKUP_BASE_PATH=/mnt
```

切换到root，添加目录写的权限：
```
chmod 777 /mnt/
```
执行备份操作:
```
lotus-miner backup /mnt/lotus-miner_back.cbor
```
备份目录：/opt/backup_lotus/



## 机器2 设置环境变量  （略过）
vi /etc/profile
```
export SSD_PATH=/mnt/nvme2
export LOTUS_PATH="/mnt/nvme1/lotus-data/"
export LOTUS_MINER_PATH="$SSD_PATH/lotus-miner-data/"
export LOTUS_STORAGE_PATH="$SSD_PATH/lotusstorage"
export WORKER_PATH="$SSD_PATH/lotusworker"
export FIL_PROOFS_PARAMETER_CACHE="$SSD_PATH/filecoin-proof-parameters"
export GOROOT=/usr/local/go
export PATH=$PATH:/root/.cargo/bin:$GOROOT/bin
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
export CGO_CFLAGS_ALLOW="-D__BLST_PORTABLE__"
export CGO_CFLAGS="-D__BLST_PORTABLE__"
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
export GOPROXY=https://goproxy.cn
export LOTUS_BACKUP_BASE_PATH=/mnt/nvme2/lotus-backup/
export RUST_LOG=info
export RUST_BACKTRACE=1
```

## 机器2 拷贝数据  （略过）
1. 复制lotus二进制文件
```
rsync -av --progress  root@192.168.26.31:/usr/local/bin/lotus-1.12.0  /usr/local/bin/
rsync -av --progress  root@192.168.26.31:/usr/local/bin/lotus-miner-1.12.0  /usr/local/bin/
ln -s lotus-1.12.0  lotus
ln -s lotus-miner-1.12.0  lotus-miner
```

2. 拷贝证明文件目录  
```
rsync -av --progress --delete  root@192.168.26.31:/mnt/nvme1/filecoin-proof-parameters/  /mnt/nvme1/filecoin-proof-parameters/
```

3. 拷贝脚本操作目录  
```
rsync -av --progress --delete  --exclude=*.log root@192.168.26.31:/home/eb/lotus-amd-eb/  /home/eb/lotus-amd-eb/
```


4. 创建lotus目录 配置权限
```
mkdir /mnt/nvme1/lotus-data/
chown -R eb:root /mnt/nvme1/lotus-data/

mkdir /mnt/nvme1/lotus-miner-data/
chown -R eb:root /mnt/nvme1/lotus-miner-data/
```

## 机器2 导入快照启动daemon  （略过）
1. 获取快照文件
- 官网下载
```
curl -sI https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car | perl -ne '/x-amz-website-redirect-location:\s(.+)\.car/ && print "$1.sha256sum\n$1.car"' | xargs wget
```

- miner机导出（推荐）  
```
lotus chain export --recent-stateroots=901 --skip-old-msgs snapshot_2022.08.26.car
```
耗费的时间与 $LOTUS_PATH 大小有关，参考如下：
目录大小5.5T，做成快照花5小时。

- 下载
```
wget -c http://115.236.19.69:3080/snapshot_2022.10.19.car
```

2. 从快照启动daemon  
检查`$LOTUS_PATH`目录是否为空，如不是则将`config.toml、keystore`等文件备份后清空目录。  
```
su - eb
lotus daemon --halt-after-import --import-snapshot <filename>
```

3. 使用脚本启动daemon
```
su - eb
cd lotus-amd-eb/script
bash rundaemon.sh
```

## 机器2 导入lotus配置
注：同时会导入钱包。
```
su - root
cd $LOTUS_PATH
cp config.toml config.toml.bak
rm -rf keystore

cd /opt/tmp
tar zxvf lotus_bak.tar.gz
cp config.toml.bak config.toml
chown -R eb:root *
```

重启daemon

## 机器2 导入矿工数据
```
su - root
cd /opt/tmp
scp root@192.168.26.83:/opt/backup_lotus/20220627/lotus-miner_back.cbor ./

cd $LOTUS_MINER_PATH   #清空该目录，否则后面的init命令执行不了。


su - eb
cd /opt/tmp
lotus-miner init restore lotus-miner_back.cbor
```

## 机器2  导入 lotus-miner 配置
```
cd /opt/tmp
cp lotusminer_bak.tar.gz $LOTUS_MINER_PATH
cd $LOTUS_MINER_PATH
tar zxvf lotusminer_bak.tar.gz

vi config.toml ，更改ip信息。
vi api ， 更改ip地址。

chown -R eb:root *
```

## 机器2 迁移扇区，挂载存储
1. 编辑 add_nfs2141.fstab
并将内容 添加到 /etc/fstab

2. 编辑 mkdir.txt
执行脚本，创建挂载目录。

3. 挂载nfs
mount -a

## 机器2 改配置
vi  /etc/security/limits.conf
```
* soft nofile 1000000
* hard nofile 1000000
```


## 机器2  启动miner
1. 启动miner
```
su - eb
cd lotus-amd-eb/script
bash runminer.sh
```

2. 确认miner启动是否成功
- 命令(需要切换到eb帐号并进入到log目录下)
```
cat miner.log*|grep -i -a 'winning PoSt warmup successful'
```
- 输出日志
```
eb@miner:~/lotus-amd-eb/log$ cat miner.log*|grep -i -a 'winning PoSt warmup successful'
2022-09-13T14:32:43.378+0800    INFO    miner   miner/warmup.go:84      winning PoSt warmup successful  {"took": 74.106073973}
2022-09-13T15:27:28.590+0800    INFO    miner   miner/warmup.go:84      winning PoSt warmup successful  {"took": 1.77205187}
2022-09-13T16:14:29.149+0800    INFO    miner   miner/warmup.go:84      winning PoSt warmup successful  {"took": 1.776434802}
2022-09-13T16:54:29.479+0800    INFO    miner   miner/warmup.go:84      winning PoSt warmup successful  {"took": 1.695575789}
```

## wdpost不成功 问题处理：
/tmp目录下的文件没删除，换了用户无法创建gpu的锁文件。



## 监控脚本
拷贝监控脚本，并添加到crontab
```
cd /home/eb/
rsync -av --progress  root@192.168.21.31:/home/eb/fil_monitor.sh  ./
```

## 机器2 attach目录
说明：挂载的存储里边已有sealed，但无sectorstore.json文件，需用命令生成。

1. 登录存储，配置目录权限
```
chmod -R 777 /mnt/data*
```

2. 登录miner，attach存储
```
lotus-miner storage attach --init --seal --store /mnt/nfs2194-1 
……
lotus-miner storage attach --init --seal --store /mnt/nfs2194-36
```

