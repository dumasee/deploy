 XWiki - 设计文档.IPFS.CHIA部署步骤 - CHIA部署步骤            

* * *

一、全节点版本安装：  
用date命令检查时间是否正常，若不正常则同步  
sudo timedatectl set-timezone 'Asia/Shanghai'  
1、安装python 3.8版本(如已装则跳过）。  
  sudo apt-get install python3.8-venv python3.8-distutils git -y  
  cd /usr/bin && rm python python3 python3m && ln -s python3.8 python3 && ln -s python3.8m python3m && ln -s python3 python  
  cd /usr/lib/python3/dist-packages && cp apt\_pkg.cpython-36m-x86\_64-linux-gnu.so apt\_pkg.cpython-38m-x86\_64-linux-gnu.so  
2、sudo apt-get update && sudo apt-get upgrade -y  
3、安装cmake最新版本  
4、建立工程目录，下载chia最新稳定版本  
  mkdir ~/chia-project && cd ~/chia-project  
  git clone [https://github.com/Chia-Network/chia-blockchain.git](https://github.com/Chia-Network/chia-blockchain.git) -b latest  
  cd chia-blockchain &&  git checkout 1.1.5  
5.安装  
  export BUILD\_VDF\_CLIENT=Y && export BUILD\_VDF\_BENCH=Y && sh install.sh

6.运行  
  . ./activate  
  chia version 检查版本是不是正确的版本  
  chia init    *初始化参数环境， $CHIA\_ROOT环境变量指定所有配置数据的目录，默认是/.chia  
  chia keys generate  
  sh install-timelord.sh  
  chia start all*

7.plot:  
  chia plots create -k 32 -n 1 -t /mnt/nvme1/chia-tmpf -d /mnt/nfs41/chia

查看同步状态;  
  chia show -s  
查看所有keys  
  chia keys show  
退出venv:  
  deactivate

二、分主机部署：  
  1、按上面步骤执行到第6步的chia init。  
  2、拷贝主节点主机$CHIA\_ROOT目录 .chia/mainnet/config/ssl/ca拷贝到本机一个位置。(注意不要拷贝整个SSL目录)  
  3、确保能telnet到主节点8447端口，使用拷过来的ssl ca 再初始化一次， chia init -c \[ca的目录\]  
  4、打开本机配置$CHIA\_ROOT目录下~/.chia/mainnet/config/config.yaml,修改harvest对应主机IP为主节点IP  
harvester:  
  chia\_ssl\_ca:  
    crt: config/ssl/ca/chia\_ca.crt  
    key: config/ssl/ca/chia\_ca.key  
  farmer\_peer:  
    host: Main.Machine.IP  
    port: 8447

  5、启动harvest, 主节点的日志中可以看到连接进来的信息。  
     chia start harvester

  6、开启plot,使用主节点的farmer key 和pool key:  
nohup chia plots create -k 32 -n 2 -t /mnt/nvme1/chia-tmpf -d /mnt/nfs41-chia/worker3 -f a9595534135def51fe28eee2b81507babe997276a6febdc8b42dbcf1215b0a2c54ee252498c7fc10ccf8c0eaffc227a9 -p b2cfdf43236cf38cd81a38448909ec4bcfca92df4c1e964e256694b31700024e6171a602f8a64f1e4df353658ef16ed9 > ../log/plot202104152159.log &  
  
  7、拷贝其它节点上/chia-project/chia-blockchain/run\_plot.sh 到本机/chia-project/chia-blockchain/. 目录，  
  chia keys show.  
  修改内容：  
  farmerkey使用主节点的farmerkey,  
  poolkey使用主节点的poolkey,  
  tmpdir使用本机ssd路径，  
  dstdir使用存储路径。  
  将存储机上的存储挂在到本机目录下，新建一个本地目录用来挂载，例如mkdir nfs602  
mount -t nfs 192.168.1.111:/mnt/data5  /mnt/nfs602   前者为挂载目录，后者后本地目录（为上面配置文件中的dstdir）  
使用df -h查看是否挂载成功

8、在~/chia-project新建log目录mkdir log  
9、修改定时任务配置crontab -e，将其他节点的配置拷贝过来  
   #第一条是18进程还没跑完时启用：  
   5,15,25,35,45,55 \* \* \* \* /root/chia-project/chia-blockchain/run\_plot.sh >> /root/chia-project/log/task.log 2>&1  
   #18进程都跑过后将第二条启用：  
   \*/1 \* \* \* \* /root/chia-project/chia-blockchain/run\_plot.sh >> /root/chia-project/log/task.log 2>&1

9、运行cd chia-blockchain/&&./run\_plot.sh.  
10、运行chia start harvester  
三、版本升级：  
cd chia-blockchain  
chia stop -d all  
deactivate  
git fetch  
git checkout latest  
*git reset hard FETCH\_HEAD*

\# If you get RELEASE.dev0 then delete the package-lock.json in chia-blockchain-gui and install.sh again

sh install.sh

. ./activate

chia init

四、

