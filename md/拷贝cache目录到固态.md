


## cache目录瘦身
操作设备：存储
```
rm -rf /mnt/data*/cache/s-t*/sc-02-data-tree-d.dat
rm -rf /mnt/data*/cache/s-t*/sc-02-data-tree-c-*
rm -rf /mnt/data*/cache/s-t*/sc-02-data-layer-*

rm -rf /mnt/data*/cache/s-t*/s-t*
```

## 列出cache扇区目录
操作设备：存储
目录带绝对路径。
```
du -sh /mnt/data*/cache/* |grep s-t |awk '{print $2}'   > 2691.cache
```



## 拷贝.cache文本
操作设备：miner
```
scp root@192.168.22.47:/root/2247.cache ./
```


## 跑脚本拷贝文件
操作设备：miner
vi run_copy2241_cache.sh
```
#!/bin/bash

sleep 3
bash copy_from_storage.sh 2241.cache 192.168.22.41  /mnt/nvme2/cache
```



## 查看拷贝情况
```
ps -ef|grep rsync

du -sh /mnt/nvme*/cache
```



**待所有cache目录 全部拷贝完成后再操作如下**
## 禁用原cache目录
操作设备：存储
```
#!/bin/bash

sleep 3

cd /mnt/data1  && mv cache cache_bak && mkdir cache
cd /mnt/data2  && mv cache cache_bak && mkdir cache
cd /mnt/data3  && mv cache cache_bak && mkdir cache
cd /mnt/data4  && mv cache cache_bak && mkdir cache
cd /mnt/data5  && mv cache cache_bak && mkdir cache
cd /mnt/data6  && mv cache cache_bak && mkdir cache
cd /mnt/data7  && mv cache cache_bak && mkdir cache
cd /mnt/data8  && mv cache cache_bak && mkdir cache
cd /mnt/data9  && mv cache cache_bak && mkdir cache
cd /mnt/data10 && mv cache cache_bak && mkdir cache
cd /mnt/data11 && mv cache cache_bak && mkdir cache
cd /mnt/data12 && mv cache cache_bak && mkdir cache
cd /mnt/data13 && mv cache cache_bak && mkdir cache
cd /mnt/data14 && mv cache cache_bak && mkdir cache
cd /mnt/data15 && mv cache cache_bak && mkdir cache
cd /mnt/data16 && mv cache cache_bak && mkdir cache
cd /mnt/data17 && mv cache cache_bak && mkdir cache
cd /mnt/data18 && mv cache cache_bak && mkdir cache
cd /mnt/data19 && mv cache cache_bak && mkdir cache
cd /mnt/data20 && mv cache cache_bak && mkdir cache
cd /mnt/data21 && mv cache cache_bak && mkdir cache
cd /mnt/data22 && mv cache cache_bak && mkdir cache
cd /mnt/data23 && mv cache cache_bak && mkdir cache
cd /mnt/data24 && mv cache cache_bak && mkdir cache
cd /mnt/data25 && mv cache cache_bak && mkdir cache
cd /mnt/data26 && mv cache cache_bak && mkdir cache
cd /mnt/data27 && mv cache cache_bak && mkdir cache
cd /mnt/data28 && mv cache cache_bak && mkdir cache
cd /mnt/data29 && mv cache cache_bak && mkdir cache
cd /mnt/data30 && mv cache cache_bak && mkdir cache
cd /mnt/data31 && mv cache cache_bak && mkdir cache
cd /mnt/data32 && mv cache cache_bak && mkdir cache
cd /mnt/data33 && mv cache cache_bak && mkdir cache
cd /mnt/data34 && mv cache cache_bak && mkdir cache
cd /mnt/data35 && mv cache cache_bak && mkdir cache
cd /mnt/data36 && mv cache cache_bak && mkdir cache
```

## attach固态
操作设备：miner
```
lotus-miner storage attach --init --seal --store /mnt/nvme2
```

## 设置目录权限
cd /mnt/nvme2
```
chown -R eb:root cache
chmod -R 755 cache
```

## 重启miner
操作设备：miner
```
su - eb
lotus-miner stop
```