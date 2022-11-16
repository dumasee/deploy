

<!-- 更新日期：2022.11.07 -->

## 操作步骤
- 查看进程，判断lotus-miner进程对应的帐号
```
ps -ef|grep lotus
```

- 切换帐号
```
su - eb
```

- 查看任务数量、封装性能
```
cd lotus-amd-eb/script/
./jobs.sh 
```

- 查看日志文件
```
cd ../log   
daemon.log
miner.log
```


- nfs目录占用情况
```
df -hT |grep nfs  
```

- 查看根分区/nvme/ssd占用情况
```
df -hT | egrep "/$|nvme[0-9]$|data[0-9]$|ssd$"   
```

## 错误扇区处理
- 查看扇区错误
```
lotus-miner proving faults
```

- 查看扇区状态(处理前后进行查看)
```
./storagefind.sh 756    |grep Sealing
./status.sh 756    |grep Status
./status.sh --log 14595
```

- 扇区状态及处理：CommitFailed
将扇区状态改为FinalizeSector
```
./finalize.sh 17608
```

- 扇区状态及处理：FinalizeFailed
```
1. 将扇区状态改为FinalizeSector
2. ./storagefind.sh 扇区号 如果sealing 为true，storage false ，去找下worker上该扇区文件，miner不能自动将扇区落盘，则手动落盘
3. 如果找不到该扇区文件，则需要重做扇区
```

## 任务超时
终止、重启任务
```
lotus-miner sealing abort  <ID>
```

## remove错误扇区
操作步骤
```
1. ./remove.sh xxxxx    #在miner上操作
2. find /mnt/nvme* -name "s-t*13025"|xargs rm -rf    #到相应worker上操作，找出的文件删除掉 
```

## 停止封装
 若nfs存储满，需要手动停封装。
1. 登录miner，crontab里边的autoplede.sh脚本注释掉。
2. 登录miner，remove.sh 还在做的任务。
   登录相应worker机，删掉对应扇区文件。
3. 清理扇区
```
find /mnt/nvme* -name "*s-t*"|xargs du -sh
find /mnt/nvme* -name "*s-t*"|xargs rm -rf
```

## mv扇区文件
扇区封装满，剩余大小不足480G，会停止封装。此时要求将已封装的扇区文件移至其它分区，以继续封装。
1. mv文件
```
ls -lh /mnt/nfs0543-1/sealed/s-t01074227-81*|wc -l
ls -lh /mnt/nfs0543-1/sealed/s-t01074227-82*

mv /mnt/nfs0543-1/sealed/s-t01074227-82* /mnt/nfs0543-2/sealed/
```
2. 重启miner

- 未封装可查看此日志找出原因
tail -10 autopledge.log


## 其它命令
**查看矿池信息**
```
lotus-miner info
lotus-miner sealing workers
lotus-miner proving deadlines
```

**查询网络延时**
正常输出为0，数值越大表示网络延时越大。
```
cd /home/eb2/lotus-amd-eb/log/
echo "scale=4;$(grep "completed mineOne" miner.log|grep -v '"nullRounds": 0'|wc -l)/$(grep "completed mineOne" miner.log|wc -l)"|bc
```


##  错误扇区恢复确认
```
root@minerAnShan2:~# lotus-miner proving faults
Miner: f01074227
deadline  partition  sectors
6         0          14595
6         0          14596
6         0          14597
6         0          14598
6         0          14599
6         0          14600
8         0          14601
8         0          14602
8         0          14603

root@minerAnShan2:~# lotus-miner proving check --slow 8
deadline  partition  sector  status
8         0          14603   good
8         0          14601   good
8         0          14602   good
root@minerAnShan2:~# 

- 查看是否有bad
lotus-miner proving check --slow 8|grep bad
```


## 手动落盘步骤
1. 查看扇区落盘状态
如果storage状态为false则要手动落盘，同时确认落盘地址是在哪台算力机。
```
eb@miner2431:~/lotus-amd-eb/script$ ./storagefind.sh 14945
In 55924452-3b5e-4e82-912b-b44f8613bc8e (Sealed, Cache)
        Sealing: true; Storage: false
        Remote
        URL: http://192.168.22.24:19201/remote/sealed/s-t0704940-14943
```
2. 手动落盘
- 查看扇区文件及路径
```
root@worker2224:~# find /mnt/nvme* -name "s-t*14945" | xargs du -sh
32G     /mnt/nvme2/lotus-worker-data/19201/sealed/s-t0704940-14943
453G    /mnt/nvme2/lotus-worker-data/19201/cache/s-t0704940-14943
```

- 删除多余文件
```
cd /mnt/nvme2/lotus-worker-data/19201/cache/s-t0704940-14943
rm -rf sc-02-data-tree-d.dat
rm -rf sc-02-data-tree-c-*
rm -rf sc-02-data-layer-*
```

- 再次确认扇区文件
```
root@worker2223:~# find /mnt/nvme* -name "s-t*15213" | xargs du -sh
32G     /mnt/nvme2/lotus-worker-data/data/sealed/s-t0704940-15213
74M     /mnt/nvme2/lotus-worker-data/data/cache/s-t0704940-15213
```

- 落盘到目标存储
用df -h查看哪个盘有空闲，确认落盘的目标存储路径。
cache目录mv到nfs存储的cache下，sealed目录mv到nfs存储的sealed目录下。
```
mv /mnt/nvme2/lotus-worker-data/19201/sealed/s-t0704940-14943 /mnt/nfs2445-1/sealed/
mv /mnt/nvme2/lotus-worker-data/19201/cache/s-t0704940-14943  /mnt/nfs2445-1/cache/
```
3. 重启miner进程
```
su - eb
lotus-miner stop 
cd lotus-amd-eb/script/ && bash runminer.sh
```


## 重做扇区文件
重做一个32G扇区文件约耗时5.5小时。
0. 准备脚本
编辑脚本 runBench-xxxx.sh，需要更改确认的参数如下：
MINER_API_INFO
miner-addr
ticket-preimage
sector-number

1. 重做
```
su - eb
cd lotus-amd-eb/bin/
bash runBench-15008.sh
```

2. 重做完成，确认文件及路径
```
root@worker2224:~# find /mnt/nvme* -name "s-t*14954" | xargs du -sh
33G     /mnt/nvme1/bench/bench103467115/unsealed/s-t0704940-14954
32G     /mnt/nvme1/bench/bench103467115/sealed/s-t0704940-14954
453G    /mnt/nvme1/bench/bench103467115/cache/s-t0704940-14954
```

3. 删除多余文件，再次确认
```
root@worker2224:~# find /mnt/nvme* -name "s-t*14954" | xargs du -sh
32G     /mnt/nvme1/bench/bench103467115/sealed/s-t0704940-14954
74M     /mnt/nvme1/bench/bench103467115/cache/s-t0704940-14954
```

4. 落盘
```
mv /mnt/nvme1/bench/bench103467115/sealed/s-t0704940-14954   /mnt/nfs2445-1/sealed/
mv /mnt/nvme1/bench/bench103467115/cache/s-t0704940-14954  /mnt/nfs2445-1/cache/
```

5. 重启miner进程
```
su - eb
lotus-miner stop 
cd lotus-amd-eb/script/ && bash runminer.sh
```

## woker机开启封装 步骤
1. 查询miner的token
```
cd $LOTUS_MINER_PATH
root@miner2131:/data1ssd/lotus-miner-data# cat token 
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.E424ou4LAoqNSSqn6avW6AHc5-7N5y5BCpQuDilJ8KM
root@miner2131:/data1ssd/lotus-miner-data# 
```

2. 更改woker的启动脚本中miner-ip及token
```
/home/eb2/lotus-1.6.0-amd-eb/scripts
eb2@worker2121:~/lotus-1.6.0-amd-eb/scripts$ 
```
- old
```
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.wG3Ll5hYV0MBMM73aV
XV4FdI5rf7mDWp53q3OezA6m8:/ip4/192.168.22.31/tcp/2345/http
```
- New
```
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.E424ou4LAoqNSSqn6avW6AHc5-7N5y5BCpQuDilJ8KM:/ip4/192.168.21.31/tcp/2345/http
```
3. 启动脚本
```
$crontab -l
*/1 * * * * /home/eb2/lotus-1.6.0-amd-eb/scripts/runworker.sh >> /home/eb2/lotus-1.6.0-amd-eb/log/runworker.log
eb2@worker2121:~$ 
```

```
# killall lotus-worker
```

4. 查看miner
```
lxl@miner2131:~/lotus-amd-eb/scripts$ ./jobs.sh 
ID        Sector  Worker    Hostname                                  Task  State    Time
9cdcb416  12181   849a32c9  worker2121-192.168.21.21:19050:PC1-nvme1  PC1   running  4m41.7s

hostname    AP  PC1  PC2  C1  C2  FIN  GET  UNS  RD
worker2121  0   1    0    0   0   0    0    0    0
Thu Oct 28 09:57:44 CST 2021
```


## woker机看日志
- miner查看job(找到相应端口)
```
lxl@miner2131:~/lotus-amd-eb/scripts$ ./jobs.sh 
ID        Sector  Worker    Hostname                                  Task  State    Time
9cdcb416  12181   849a32c9  worker2121-192.168.21.21:19050:PC1-nvme1  PC1   running  6h57m20.2s
2b6890d1  12182   8439d99b  worker2121-192.168.21.21:19063:PC1-nvme2  PC1   running  6h32m46.2s

hostname    AP  PC1  PC2  C1  C2  FIN  GET  UNS  RD
worker2121  0   2    0    0   0   0    0    0    0
Thu Oct 28 16:50:23 CST 2021
```
- worker机查看日志
```
tail -500 19063.log |grep -v JWT
```

## miner启用封装
```
bash autopledge.sh
```
手动运行的话，运行一次就是开启一个扇区封装，里边有参数控制最大开启的封装数。


## 扇区延期
1. 查询最近1个月到期的扇区
```
lotus-miner sectors list|egrep 'in [1-4] weeks'|more
```
2. 延期命令
```
su - eb
lotus-miner sectors renew --really-do-it
```
延期操作需要消耗FIL，操作成功会上发`ExtendSectorExpiration`消息。

