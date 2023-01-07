
## 存储配置
```
存储1(192.168.3.51):   RAID6  做了2个阵列(12+24)  1块阵列卡(Adaptec Series 8 12G SAS/PCIe 3) 
存储2(192.168.3.62)：  RAID5  做了2个阵列(12+24)  1块阵列卡(LSI MegaRAID SAS-3 3108)   
存储3(192.168.3.248)： RAID6  做了3个阵列(12+12+12) 2块阵列卡(LSI MegaRAID SAS-3 3108) 
```

## 存储io测试
- 存储1
```
本机io测试：
root@store-w-001:~# dd if=/dev/zero of=/storage1/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 0.790543 s, 1.3 GB/s

miner机写nfs测试：
root@miner-w-001:~# dd if=/dev/zero of=/storage/lotusstorage1/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.5969 s, 657 MB/s
```

- 存储2
```
本机io测试：
root@store-w-002:~# dd if=/dev/zero of=/storage1/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.49229 s, 703 MB/s

miner机写nfs测试：
root@miner-w-001:~# dd if=/dev/zero of=/storage/lotusstorage3/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.23452 s, 469 MB/s


```

- 存储3
```
本机io测试：
root@storage248:~# dd if=/dev/zero of=/mnt/data1/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.33838 s, 783 MB/s

miner机写nfs测试：
root@miner-w-001:~# dd if=/dev/zero of=/storage/lotusstorage31/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.42557 s, 432 MB/s
```


- 结果汇总
```
       本机io测试    miner机nfs写入测试
存储1   1.3 GB/s     657 MB/s
存储2   703 MB/      469 MB/s
存储3   783 MB/      432 MB/s
```


## 算力机到存储3 网络&io 测试
- worker2
```
测试到存储的网络：
root@worker240:~# iperf3 -c 192.168.3.248 -b 10000M -n 5G
Connecting to host 192.168.3.248, port 5201
[  5] local 192.168.3.240 port 40600 connected to 192.168.3.248 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.09 GBytes  9.33 Gbits/sec   11   1.39 MBytes
[  5]   1.00-2.00   sec  1.10 GBytes  9.42 Gbits/sec    9   1.40 MBytes
[  5]   2.00-3.00   sec  1.10 GBytes  9.41 Gbits/sec   15   1.40 MBytes
[  5]   3.00-4.00   sec  1.10 GBytes  9.42 Gbits/sec    0   1.41 MBytes
[  5]   4.00-4.57   sec   641 MBytes  9.42 Gbits/sec    0   1.41 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-4.57   sec  5.00 GBytes  9.40 Gbits/sec   35             sender
[  5]   0.00-4.57   sec  5.00 GBytes  9.39 Gbits/sec                  receiver

iperf Done.
root@worker240:~#

测试nfs写存储：
root@worker240:~# dd if=/dev/zero of=/storage/lotusstorage31/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.72309 s, 385 MB/s
root@worker240:~# dd if=/dev/zero of=/storage/lotusstorage32/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.45096 s, 428 MB/s
```


- worker3
```
测试到存储的网络：
root@worker242:~# iperf3 -c 192.168.3.248 -b 10000M -n 5G
Connecting to host 192.168.3.248, port 5201
[  5] local 192.168.3.242 port 46710 connected to 192.168.3.248 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   954 MBytes  8.00 Gbits/sec   27   1.22 MBytes
[  5]   1.00-2.00   sec   897 MBytes  7.52 Gbits/sec    8   1.40 MBytes
[  5]   2.00-3.00   sec  1.04 GBytes  8.97 Gbits/sec    0   1.41 MBytes
[  5]   3.00-4.00   sec   818 MBytes  6.86 Gbits/sec    0   1.44 MBytes
[  5]   4.00-5.00   sec  1001 MBytes  8.40 Gbits/sec    2   1.45 MBytes
[  5]   5.00-5.46   sec   380 MBytes  6.94 Gbits/sec    0   1.47 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-5.46   sec  5.00 GBytes  7.87 Gbits/sec   37             sender
[  5]   0.00-5.46   sec  5.00 GBytes  7.86 Gbits/sec                  receiver

iperf Done.


测试nfs写存储：
root@worker242:~# dd if=/dev/zero of=/storage/lotusstorage31/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 3.41682 s, 307 MB/s
root@worker242:~# dd if=/dev/zero of=/storage/lotusstorage32/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 3.18958 s, 329 MB/s

```

- worker4
```
测试到存储的网络：
root@worker244:~# iperf3 -c 192.168.3.248 -b 10000M -n 5G
Connecting to host 192.168.3.248, port 5201
[  5] local 192.168.3.244 port 57194 connected to 192.168.3.248 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.10 GBytes  9.42 Gbits/sec    0   1.50 MBytes
[  5]   1.00-2.00   sec  1.10 GBytes  9.41 Gbits/sec    0   1.50 MBytes
[  5]   2.00-3.00   sec  1.10 GBytes  9.41 Gbits/sec    0   1.50 MBytes
[  5]   3.00-4.00   sec  1.10 GBytes  9.41 Gbits/sec    1   1.06 MBytes
[  5]   4.00-4.56   sec   630 MBytes  9.42 Gbits/sec    0   1.34 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-4.56   sec  5.00 GBytes  9.42 Gbits/sec    1             sender
[  5]   0.00-4.56   sec  5.00 GBytes  9.41 Gbits/sec                  receiver

iperf Done.


测试nfs写存储：
root@worker244:~# dd if=/dev/zero of=/storage/lotusstorage31/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.50058 s, 419 MB/s
root@worker244:~#
root@worker244:~# dd if=/dev/zero of=/storage/lotusstorage32/testf1 bs=1M count=1000 conv=fdatasync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.49416 s, 420 MB/s
```


## 2021.7.6
worker2(240) -> /storage/lotusstorage4   1分钟不到拷完。
worker2(240) -> /storage/lotusstorage31/    超时了。。


dd if=/dev/zero of=./testf1 bs=1M count=32000 conv=fdatasync



- wget/http测试内网下载
```
wget -c 192.168.3.248/ubuntu-20.04.2-live-server-amd64.iso
wget -c 192.168.3.240/ubuntu-20.04.2-live-server-amd64.iso
wget -c 192.168.3.240/s-t0110808-30053

```

- 测试scp脚本
```
echo started...
cd /mnt/nvme1/lotus-worker-data/19200/sealed/
date && sshpass -p Ubuntu123! scp s-t0110808-30053 root@192.168.3.248:/mnt/data1/test && date
echo finished.
```


/storage/lotusstorage31 from 192.168.3.248:/mnt/data1
 Flags: rw,relatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.3.240,local_lock=none,addr=192.168.3.248

/storage/lotusstorage32 from 192.168.3.248:/mnt/data2
 Flags: rw,relatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.3.240,local_lock=none,addr=192.168.3.248

/storage/lotusstorage33 from 192.168.3.248:/mnt/data3
 Flags: rw,relatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.3.240,local_lock=none,addr=192.168.3.248



192.168.3.248:/mnt/data1 /storage/lotusstorage31 nfs defaults,noatime,timeo=5,retrans=3,soft,_netdev 0 0
192.168.3.248:/mnt/data2 /storage/lotusstorage32 nfs defaults,noatime,timeo=5,retrans=3,soft,_netdev 0 0
192.168.3.248:/mnt/data3 /storage/lotusstorage33 nfs defaults,noatime,timeo=5,retrans=3,soft,_netdev 0 0

- 查看nfs目录挂载参数
```
nfsstat -m
```

- 测试nfs拷贝
```
cd /mnt/nvme1/lotus-worker-data/19200/sealed/
date && cp s-t0110808-30053 /storage/lotusstorage4/test/ && date

date && cp s-t0110808-30053 /storage/lotusstorage31/test/ && date


```



date && cp ubuntu-20.04.2-live-server-amd64.iso /storage/lotusstorage31/ && date

- worker2  ->  storage3
协议方法     文件大小    时间
wget/http     32G     45s


## 本机dd写文件
- 安装测试工具
```
apt-get install sysstat
iostat -dxm 1 5
```

- 测试命令
cd /mnt/data1/test
dd if=/dev/zero of=./testf1 bs=1M count=30000 conv=fdatasync

- 结果汇总
```
       本机dd写文件    时间
存储1   32G         16.8s/28.8s
存储2   32G         24.5s/40.3s
存储3   32G         55s/63s/43.8/38.3s/36.3s
```


- nfs拷贝前后的内存情况
```
root@store-w-002:~# free -h
              total        used        free      shared  buff/cache   available
Mem:          251Gi       1.2Gi       249Gi       2.0Mi       1.0Gi       249Gi
Swap:            0B          0B          0B
root@store-w-002:~#


root@store-w-002:~# free -h
              total        used        free      shared  buff/cache   available
Mem:          251Gi       1.2Gi       216Gi       2.0Mi        33Gi       248Gi
Swap:            0B          0B          0B
root@store-w-002:~#
```


root@storage248:~# free -h
              total        used        free      shared  buff/cache   available
Mem:          125Gi       1.0Gi       124Gi       2.0Mi       259Mi       123Gi
Swap:         8.0Gi       4.0Mi       8.0Gi
root@storage248:~#


## worker2通过nfs dd拷贝到存储
- 命令
```
dd if=/dev/zero of=/storage/lotusstorage1/test/testf1 bs=1M count=30000 conv=fdatasync
dd if=/dev/zero of=/storage/lotusstorage4/test/testf1 bs=1M count=30000 conv=fdatasync
dd if=/dev/zero of=/storage/lotusstorage31/test/testf1 bs=1M count=30000 conv=fdatasync
```

- 测试记录
```
       worker2通过nfs写文件    时间
存储1   32G        45.1s
存储2   32G        40.1s
存储3   32G        581.8s
```



- 存储server挂载参数

/storage1 *(rw,async,no_root_squash)
/storage2 *(rw,async,no_root_squash)
root@store-w-001:~#


/storage1 *(rw,sync,no_root_squash)
/storage2 *(rw,sync,no_root_squash)
root@store-w-002:~#


/mnt/data1/ *(rw,insecure,sync,no_root_squash,no_subtree_check)
/mnt/data2/ *(rw,insecure,sync,no_root_squash,no_subtree_check)
/mnt/data3/ *(rw,insecure,sync,no_root_squash,no_subtree_check)
root@storage248:~#


将存储3挂载参数改成存储1的样式：
/mnt/data1/ *(rw,async,no_root_squash)
/mnt/data2/ *(rw,async,no_root_squash)
/mnt/data3/ *(rw,async,no_root_squash)


- 客户端挂载目录
192.168.3.248:/mnt/data1 /storage/lotusstorage31 nfs defaults,noatime,_netdev 0 0
192.168.3.248:/mnt/data2 /storage/lotusstorage32 nfs defaults,noatime,_netdev 0 0
192.168.3.248:/mnt/data3 /storage/lotusstorage33 nfs defaults,noatime,_netdev 0 0


## 并发测试
- 测试方法
同时从算力2，算力3 拷贝32G文件至 存储3的两个目录
同时从算力2，算力3，算力4 拷贝32G文件至 存储3的三个目录

- 命令
```
算力2:
cd /mnt/nvme1/lotus-worker-data/19200/sealed/
date && cp s-t0110808-30053 /storage/lotusstorage31/test/ && date

算力3:
date && cp s-t0110808-30053 /storage/lotusstorage32/test/ && date


算力4:
date && cp s-t0110808-30053 /storage/lotusstorage33/test/ && date
```

- 测试结果
```
2个并发：
（算力2、算力3通过nfs拷贝32G文件至存储3的2个目录）
        时间
算力2   53s
算力3   54s
```
3个并发：
（算力2、算力3、算力4通过nfs拷贝32G文件至存储3的3个目录）
        时间
算力2    56s
算力3    56s
算力4    66s
```