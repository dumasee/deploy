
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [目录挂载](#目录挂载)
- [miner操作](#miner操作)
- [副miner操作](#副miner操作)
- [故障记录](#故障记录)

<!-- /code_chunk_output -->


## 目录挂载
miner(也包括副miner) & worker 上都需要挂载存储目录。
操作帐号：root

- miner
1. 更改/etc/fstab文件添加新存储
vi /etc/fstab 添加：
```
192.168.22.54:/mnt/data1 /mnt/nfs2254-1 nfs defaults,_netdev 0 0
192.168.22.54:/mnt/data2 /mnt/nfs2254-2 nfs defaults,_netdev 0 0
192.168.22.54:/mnt/data3 /mnt/nfs2254-3 nfs defaults,_netdev 0 0
```
2. 创建目录
```
mkdir -p /mnt/nfs2254-1
mkdir -p /mnt/nfs2254-2
mkdir -p /mnt/nfs2254-3
```
3. 挂载
```
mount -a
```

- worker
说明：与miner机不同，worker机不需要永久挂载nfs存储，因此不需要写入fstab。
1. 在miner上执行 查询启用了哪些worker，将这些worker的ip记录下来。
```
lotus-miner sealing workers|grep AP
```
2. 更改所有参与封装的算力机，创建挂载点，并使用mount命令手动挂载nfs目录。

3. 使用脚本：
```
1. 编辑 tmp.ip ，录入所有参与封装的worker的地址。
2. 编辑 nfs.fstab，录入miner上新挂载的存储记录。内容直接从miner机的/etc/fstab文件获取。
3. 命令：bash nfs_mount_genscript.sh ，生成执行脚本。
4. 命令：bash runscript.sh addNFS.sh tmp.ip ，完成远端主机上批量nfs挂载操作。
```

## miner操作
操作帐号：root
1. 存储机目录权限设置
登录存储机：
```
chmod -R 777 /mnt/nfs2254-*
```
2. 命令执行
登录miner机：
```
lotus-miner storage attach --init --seal --store /mnt/nfs2254-1
lotus-miner storage attach --init --seal --store /mnt/nfs2254-2
lotus-miner storage attach --init --seal --store /mnt/nfs2254-3
```

## 副miner操作
个别集群有单独的主机作为副miner，例如北京1的副miner为：ipfs2-miner2
或者是相同主机的副进程，例如eb2帐号下的miner
1. 更改文件 storage.json 内容，与miner1相同。
文件路径：$LOTUS_MINER_PATH
直接copy主miner的文件，然后再更改文件权限属性。
```
chown eb:root storage.json
chmod 644 storage.json
```

2. 重启miner进程
```
su - eb
cd lotus-amd-eb/script/
lotus-miner stop
bash runminer.sh
```

3. 查看挂载情况
```
lotus-miner storage list
```

## 故障记录
现象：ERROR: path is already initialized
未生成子目录。
操作：
```
lotus-miner storage attach  --seal --store /mnt/nfs0544-2
lotus-miner storage attach  --seal --store /mnt/nfs0544-3
```
