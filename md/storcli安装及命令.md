## 安装
```
cd /opt/deploy/ && dpkg -i storcli_007.1613.0000.0000_all.deb
ln -s /opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli
```

## 命令
```
storcli show  #查看阵列卡信息
storcli /call show   #显示TOPOLOGY，VD LIST，PD LIST
storcli /call/eall/sall show  #显示Drive Information
storcli /call show | grep "Virtual Drives"   #查看虚拟盘数量
storcli /c0/vall show  #查看虚拟盘
storcli /call/dall show  #显示TOPOLOGY
storcli /c0/dall show
storcli /c1/dall show
storcli /call/eall/sall show rebuild


storcli /cx[/ex]/sx set good [force]

storcli /cx[/ex]/sx start locate
storcli /cx[/ex]/sx stop locate

storcli /c0 show rebuildrate
storcli /c0 set rebuildrate=60
```

## 故障盘恢复
- 故障盘恢复，故障显示为Unconfigured(bad)
1. 查看阵列信息，定位故障盘
```
storcli /c1/e25/s0 show
```

2. 设置故障盘为good
对于unconfigured bad，或JBOD类型的磁盘，可以使用此命令，
将盘状态改为unconfigured good状态，然后才能加入阵列。
```
storcli /c1/e25/s0 set good
```

3. 导入硬盘配置
注：硬盘处于unconfigured good状态，不能自动进入rebuild，需要执行此操作。
```
storcli /c1/fall show  #查找外部配置
storcli /c1 /fall import  
```
4. 查看rebuild
```
storcli /c1/e25/s0 show rebuild
```


## 删除硬盘配置
重做阵列之前，需要删除原硬盘上的配置信息。
```
storcli /c0 /fall del   
```

## 禁用copyback
```
storcli /call set copyback=off type=all
storcli /call show copyback
storcli /call show autorebuild
```

## jbod改成阵列，并配置raid10
```
storcli /c0 set jbod=off
storcli /c1 set jbod=off
storcli /c0 add vd type=raid10 size=all names=vd01 drives=32:0-11 pdperarray=6
storcli /c1 add vd type=raid10 size=all names=vd11 drives=25:0-11 pdperarray=6
storcli /c1 add vd type=raid10 size=all names=vd12 drives=25:12-23 pdperarray=6
```

## 删除阵列
```
storcli /c0 /v0 delete force
```


## 北京1新上存储命令配置阵列
说明：新到的机器有阵列配置，由于硬盘拆出来寄快递，因此重新安装后阵列盘状态完全不对，需要重做阵列。
1. 删除外部硬盘配置
```
storcli /c0 /fall del
storcli /c1 /fall del
```

2. 删除阵列配置
```
storcli /c0 /v0 delete force
```

3. 添加阵列
```
storcli /c0 set jbod=off
storcli /c1 set jbod=off
storcli /c0 add vd type=raid10 size=all names=vd01 drives=32:0-11 pdperarray=6
storcli /c1 add vd type=raid10 size=all names=vd11 drives=25:0-11 pdperarray=6
storcli /c1 add vd type=raid10 size=all names=vd12 drives=25:12-23 pdperarray=6
```


## 查询全局是否开启jbod
storcli /c0 show all|grep -i jbod

## 硬盘设置成jbod
storcli /c0/e16/s0-s23 set jbod
storcli /c1/e16/s0-s11 set jbod