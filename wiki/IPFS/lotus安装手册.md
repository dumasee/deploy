 XWiki - 设计文档.IPFS.lotus安装手册 - lotus安装手册            

* * *

 安装依赖

1、\[安装 go\]

\`\`\`bash  
wget -c [https://golang.org/dl/go1.15.5.linux-amd64.tar.gz](https://golang.org/dl/go1.15.5.linux-amd64.tar.gz) -O - | sudo tar -xz -C /usr/local

tar -zxvf go1.15.5.linux-amd64.tar.gz -C /usr/local

export GOROOT="/usr/local/go"  
export GOPATH="/usr/local/gopath"  
export PATH=$PATH:/root/.cargo/bin:$GOROOT/bin

export GOROOT=/usr/local/go  
export PATH=$PATH:$HOME/.cargo/bin:$GOROOT/bin  
\`\`\`

2、安装其它依赖

\`\`\`  
sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev -y && sudo apt upgrade -y  
\`\`\`

3、\[安装 rustup\]

\`\`\`  
curl proto '=https' tlsv1.2 -sSf [https://sh.rustup.rs](https://sh.rustup.rs) | sh  
\`\`\`

安装完，想在终端立即生效：

\`\`\`  
source $HOME/.cargo/env  
\`\`\`

 2.2 下载 Lotus

\`\`\`  
svn co [svn://47.93.220.40:9999/](svn://47.93.220.40:9999/)项目列表/IPFS分布式存储项目/开发管理/filecoin-project  
\`\`\`

 2.3 编译安装

\`\`\`bash  
cd lotus/

#使用intel CPU  
FFI\_BUILD\_FROM\_SOURCE=1 CGO\_CFLAGS="-O -DBLST\_PORTABLE" make clean all

#使用amd cpu  
RUSTFLAGS="-C target-cpu=native -g" FFI\_BUILD\_FROM\_SOURCE=1 make clean all

#安装  
make install  
\`\`\`

 3.1 开始启动daemon进程

启动守护进程

\`\`\`  
nohup lotus daemon >> daemon.log &  
\`\`\`

**额外说明：**

守护进程启动后，会默认生成～/.lotus 文件。（在进行同步工作中）

 3.2 链同步

运行下面的命令查看链同步进度。要查看当前链高度：

\`\`\`  
lotus sync wait  
\`\`\`

这一步需要几个小时到几天的时间。（取决于链的高度），可以下载离线包https:*fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal\_finality\_stateroots\_latest.car  
使用离线包启动  
\`\`\`  
lotus daemon import-snapshot /mnt/nvme1/minimal\_finality\_stateroots\_latest.car  
\`\`\`*

 4.1 创建矿工

创建矿工前先下载封装扇区需要的参数数据（101G），可以避免创建矿工的时间过长  
\# 设置国内的零知识证明参数下载源  
export IPFS\_GATEWAY="[https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/](https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/)"  
\# 手动下载零知识证明参数到FIL\_PROOFS\_PARAMETER\_CACHE目录中，有200GB  
lotus fetch-params 32GiB

请使用以下命令确保钱包中至少存在一个**BLS**地址：  
\`\`\`  
lotus wallet list  
\`\`\`

如果您没有 bls 钱包地址，请创建一个新的 bls 钱包地址：

\`\`\`  
lotus wallet new bls  
\`\`\`

**初始化矿工**

\`\`\`bash  
#proof 证明参数路径: FIL\_PROOFS\_PARAMETER\_CACHE  
export FIL\_PROOFS\_PARAMETER\_CACHE=/filecoin-proof-parameters

lotus-miner init actor=ACTOR\_VALUE\_RECEIVED owner=OWNER\_VALUE\_RECEIVED

例如：  
lotus-miner init owner=f3v2tbwj5t7naqvg5hzqzfk7psnr3d3fc2j7v6lg6mwp3is3gh44aimhbwmdh7wgadydpxmg5kzko7twdve2xq worker=f3r73wgj7e6p6tfgzpp7s4fvbfglywjuow3own7ljzrh5ggwc7pdjjarga66fbid5bawbda6tdberbheachlza

\`\`\`

**额外说明：**  
初始化完后，会默认生成/.lotusminer 文件  
默认路径可以通过 LOTUS\_MINER\_PATH 改

 4.2 运行矿工

\`\`\`  
执行我们程序包的中的runminer.sh或者Restartminer\_main.sh，即可启动  
\`\`\`

获取有关矿工的信息：

\`\`\`  
lotus-miner info  
\`\`\`

设置存储路径  
\`\`\`  
lotus-miner storage attach init seal store  /mnt/nfs1  
lotus-miner storage attach init seal store  /mnt/nfs2  
\`\`\`

封装一个新的扇区：

\`\`\`bash  
lotus-miner sectors pledge  
\`\`\`  
**Lotus Worker**是一个额外的进程，可以从**Lotus Miner**卸载繁重的处理任务。它可以与您的\`lotus-miner\`在同一台计算机上运行，也可以在另一台通过快速网络通信的计算机上运行。

**设置worker的windowpost地址（给windowpost新建一个独立的地址，避免windpost消息被同地址的其他消息阻塞）：**

创建control地址并转一点fil进去（3个fil就可以用很久，当前windowpost的gas费很低）  
lotus wallet new bls  
lotus send from $old\_address $new\_control\_address amount

\`\`\`bash  
./lotus-miner actor control set really-do-it $new\_control\_address  
\`\`\`

\# **查看扇区状态**

\`\`\`bash  
\# 列举所有扇区信息:  
lotus-miner sectors list  
\# 查看某个扇区的历史状态  
lotus-miner sectors status log <SectorID>  
\`\`\`

 5.2 网络运行

要使用完全独立的计算机执行密封任务，您需要在单独的计算机上运行 \`lotus-worker\` ，该计算机通过局域网连接到您的lotus-Miner。

首先，您需要确保可以通过网络访问\`lotus-miner\`的API。

为此，打开\`/.lotusminer/config.toml\`（或者如果手动设置\`LOTUS\_MINER\_PATH\`，请在该目录下查找）并查找 API 字段。

Default config:

\`\`\`  
\[API\]  
ListenAddress = "/ip4/127.0.0.1/tcp/2345/http"  
RemoteListenAddress = "127.0.0.1:2345"  
\`\`\`

要通过局域网访问节点，需要确定局域网上的计算机 IP，并将文件中的 \`127.0.0.1\` 更改为miner的IP地址。

一个更宽松、更不安全的选项是将其更改为\`0.0.0.0\`。这将允许任何可以连接到该端口上的计算机的人访问，但是他们仍然需要一个身份验证令牌。

\`RemoteListenAddress\`必须设置为网络上其他节点可以访问的地址

获取miner的身份验证令牌

\`\`\`bash  
lotus-miner auth create-token perm admin  
\`\`\`

\# 5.2.1 Connect the Lotus Worker

在将运行\`lotus-worker\`的计算机上，将\`STORAGE\_API\_INFO\`环境变量设置为\`TOKEN:STORAGE\_NODE\_MULTIADDR\`. 其中，\`TOKEN\`是我们在上面创建的令牌，\`STORAGE\_NODE\_MULTIADDR\`是在中设置的**Lotus Miner** API 的\`multiaddr\`在\`config.toml\`.

设置后，运行：

\`\`\`bash

#更换脚本runworker.sh的STORAGE\_API\_INFO环境变量  
export MINER\_API\_INFO="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.Fu0eZLcDerfgzaTyFBUXv\_twESWsRHjL1hE9uZvBZmk:/ip4/0.0.0.0/tcp/2345/http"  
#执行脚本即可启动P1-P2-C1的程序

#更换脚本runworkerC2.sh的STORAGE\_API\_INFO环境变量  
#执行脚本即可启动C2的worker程序

\`\`\`

要检查**Lotus Worker**是否已连接到**Lotus Miner**上，请运行\`lotus-miner sealing workers\` ，并检查远程工作者计数是否已增加。

\`\`\`  
#查看  
lotus-miner sealing workers  
\`\`\`

**Lotus安装后的检查点**  
1，用户是否存在  
2，用户下的环境变量是否正确  
3，关键文件是否在对应目录（empty，parameter）  
4，依赖库是否都已经安装完成  
5，关键目录权限是否正确，算力和超算（/mnt/nfs，/mnt/nvme，）  
6，ulimit是否正确（参考现有矿池的配置）  
ulimit修改1000000/1000000（miner）  
20480/65535 worker  
vi /etc/security/limits.conf  
miner示例：

+   soft nofile 1000000
+   hard nofile 1000000  
    worker示例：
+   soft nofile 20480
+   hard nofile 65535  
    7，时区是否正确  
    8，挂载目录是否分布正常  
    9，controler地址是否增加  
    10，待执行脚本的显卡配置参数是否正确，miner没有该参数会造成windowpost上发失败(CUDA\_VISIBLE\_DEVICES)

