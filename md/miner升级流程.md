### 关闭程序

1. 关闭 miner 进程
   通过lotus-miner stop命令关闭miner进程
   通过 ``` ps -ef | grep lotus-miner ``` 查看进程，执行下一步前确保 miner 进程完全退出

2. 关闭 daemon 进程
   通过 lotus daemon stop 命令关闭daemon进程
   通过 ``` ps -ef | grep lotus``` 查看进程，执行下一步前确保完 daemon  进程全退出   

### 升级

1. 升级固件
- 工具下载  
https://downloadmirror.intel.com/30162/eng/Intel%C2%AE_MAS_CLI_Tool_Linux.zip

- 查看当前系统ssd型号及数量  
intelmas show -intelssd|grep ^- 

- 查看当前系统ssd版本升级信息  
intelmas show -intelssd|grep -B1 Index 

- 执行升级操作  
intelmas load -intelssd Index

- 升级后确认  
intelmas show -intelssd|grep -B1 Index 

2. 升级程序  
   拷贝lotus程序到miner指定目录  
   通过sudo make install 安装到指定目录 /usr/local/bin 中  

3. 升级成功

### 重启程序

1. 启动  daemon 进程  
   1. 通过 ``` nohup lotus daemon >> /home/lxl/lotus-1.5.0-amd-eb/log/daemon.log & ``` 启动 daemon 进程
   2. 通过 ``` lotus sync status``` 命令查看同步状态
   3. 通过 ``` lotus sync wait ``` 等待同步结束
   
2. 启动 miner 程序  
   1.运行 ``` /home/lxl/lotus-1.5.0-amd-eb/script ``` 目录下 ``` runminer.sh ``` 启动 miner
   2.运行 ``` lotus-miner info ``` 确认 miner 启动成功
   3.运行 ``` lotus-miner version ``` 确认版本号