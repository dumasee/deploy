添加新硬盘

1. fdisk进行分区
```
fdisk -l  #查看已连接的硬盘
fdisk /dev/vdb  #指定新加的硬盘进行操作，进入后的操作：p -> n,回车,回车,回车,回车 ->  p,w
```

2. 分区格式化
```
mkfs.xfs /dev/vdb1  #对分区进行格式化
mkdir /data &&  mount /dev/vdb1 /data -o defaults
```

3. 添加分区到fstab文件
vi /etc/fstab，添加：
```
UUID=c08d13d1-fb9c-427e-8017-61ecaf6722ce /data1 xfs defaults 0 2
UUID=dffeadd9-489e-475c-a064-bff11383af75 /data2 xfs defaults 0 2
UUID=43d31c17-3644-4aa7-b2fb-bd1c65796e12 /data3 xfs defaults 0 2
```
或执行：
```
echo UUID="22910370-cbf6-4706-b07c-4164dab59159"  /data1 xfs defaults 0 2 >> /etc/fstab
echo UUID="83c45f1a-e10d-4c50-9d99-f0eabeea64cb"  /data2 xfs defaults 0 2 >> /etc/fstab
（使用命令blkid查看硬盘UUID）
```


