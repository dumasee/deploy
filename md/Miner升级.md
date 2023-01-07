<center>miner升级步骤</center>

1. 安装新版 bins 到文件到目标机器
   1. 将开发提供的新版二进制文件分发到目标机器
   2. 在新版二进制文件夹内通过执行 ```sudo make install``` 命令安装新版二进制文件
   3. 安装完成后通过 ``` lotus --version ``` 命令确认版本号
   
2. 关闭调度进程
   
   1. 首先**关闭** corntab 里的定时自动 pledge 任务；
   
   2. 通过ps-ef|greplotus命令查看调度进程PID，通过kill命令关闭调度进程，并通过tail-f
      命令查看调度程序程序日志，执行下一步前确保调度程序完全退出，并通过 ```ps -ef | grep lotus``` 进行验
      证
   
      **注意：切勿通过kill-9命令关闭调度程序，调度程序退出需要5s-30min时间，要耐心**
      **等待**
   
3. 关闭 miner 进程

   通过lotus-miner stop命令关闭miner进程，需要一定时间，要耐心**等待**，通过 ``` ps -ef | grep lotus-miner ``` 查看进程，执行下一步前确保 miner 进程完全退出

4. 关闭 daemon 进程

   1. 通过 lotus daemon stop 命令关闭daemon进程，需要一定时间，要耐心**等待**，通过 ``` ps -ef | grep lotus``` 查看进程，执行下一步前确保完 daemon  进程全退出

5. 启动  daemon 进程

   1. 通过 ```nohup lotus daemon >> daemon.log &``` 启动 daemon 进程
   2. 通过 ``` lotus version ``` 确认版本号
   3. 通过 ```watch lotus sync status``` 命令查看同步状态
   4. 通过 ``` lotus sync wait ``` 等待同步结束

6. 启动  miner 进程

   1. 通过以下命令启动 miner 进程

   ```
   export LOTUS_BACKUP_BASE_PATH=/mnt
   export RUST_LOG=info
   export RUST_BACKTRACE=1
   nohup lotus-miner run >> miner.log&
   ```

   2. 通过 ``` lotus-miner version ``` 确认版本号

7. **重启该 Miner 用到的所有 C2 进程**

8. 启动调度进程

   1. 启动调度前需要通过查看miner日志保证 miner 已经稳定运行，具体为完成密封任务重新分配，两分钟内无任务重新分配日志
   2. 通过 ``` nohup lotus-schedule run >> scheduler.log&``` 启动调度程序
   3. 启动 crontab 里的定时自动 pledge 任务





