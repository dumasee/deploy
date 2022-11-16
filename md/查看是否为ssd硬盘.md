
- 命令  
```
cat /sys/block/sda/queue/rotational
```

- 说明  
命令中的sba是你的磁盘名称，可以通过df命令查看磁盘，然后修改成你要的  

- 结果  
```
返回0：SSD盘
返回1：SATA盘
 ```