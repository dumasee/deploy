## miner拆分步骤：
1. 新增用户eb2：
```
新增用户：adduser eb    密码：p#wlD4W8k73q
添加权限：vi /etc/sudoers
修改用户属主：usermod -g 0 eb （0是组id，eb用户）
```
2. 查看$LOTUS_MINER_PATH/sectorid中miner 最大扇区号
查看方法： 
```
vi /home/eb/lotus-amd-eb/log/autopledge.log  排序查看最大扇区号sectorid
```
3. 在确保所有封装任务都结束的情况下并且不在windpost时间段后，停止miner进程。
4. 在用户eb2下创建$LOTUS_PATH路径，不与主用户下相同，把主用户的$LOTUS_PATH下的api和token拷贝到此目录下。
5. 在用户eb2下创建$LOTUS_MINER_PATH路径，不与主用户下相同。把主用户的$LOTUS_MINER_PATH下文件全部拷贝到副用户对应目录下，并修改config.toml文件，把监听端口号修改为另一个端口号，并修改目录权限chown -R eb4 lotus-miner-data-eb4。
6. 修改主用户下$LOTUS_MINER_PATH/sectorid文件(首次部署需要创建该文件)，将其中的数字改为大于当前所有扇区ID的一个数字。
7. 在副目录下新增miner启动脚本路径 
```
mkdir -p /home/eb2/lotus-amd-eb/script
```
新增日志目录
```
mkdir -p /home/eb2/lotus-amd-eb/log
```
新增显卡环境目录： 
```
mkdir -p /tmp/miner-eb2
```
8. 先改启动配置然后启动主目录下的lotus-miner 做扇区分配，再启动副目录下的lotus-miner 做wdpost和wnpost.
```
nohup lotus-miner run --wdpost=true --wnpost=false --p2p=false --sctype=alloce --sclisten=192.168.21.31:1357 >> log/miner.log &
nohup lotus-miner run --wdpost=false --wnpost=true --p2p=false --sctype=get --sclisten=192.168.21.31:1357 >> log/miner.log &
```
## 注意事项
1. miner启动项需要更改启动判断|grep wdpost=true 或者|grep wdpost=false
2. 拆分的miner启动项需要新增LOTUS_MINER_PATH和LOTUS_PATH 环境配置
3. 增加新增miner的日志清除脚本和自动启动脚本
4. 启动报权限不足 要更改目录权限 chown -R eb4 lotus-miner-data-eb4
注：拷贝后新封装的扇区的wnpost是否生效需要确认。