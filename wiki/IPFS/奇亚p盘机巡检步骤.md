巡检主要检查点：
1. 根目录是否被占满
```
df -h / 查看/目录的占用率
```
2. /mnt/nvme1是否被占满
```
df -h |grep /mnt/nvme1
```
3. nfs存储使用量是不是快满了。查找chia进程中-d后的挂载路径
```
d df -h /mnt/nfs12/
-aa
```
4. ~/chia-project/log/目录下grep "Total time" *.log 统计P盘效率
```
 cd ~/chia-project/log/&& grep "Total time" *.log
```
5. 新加的P好的目录要挂载到server1上,  并且在chia plots show 显示列表里
```
chia plots show查看当前挂载存储是否在列表内，
cd ~/chia-project/chia-blockchain&&. ./activate&&chia plots show
```
不在列表内则挂载一下，挂载命令为
```
chia plots add -d [dir]
```