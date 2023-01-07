ubuntu部署filecoin挖矿节点 (lotus)

## 安装环境 
sudo apt update
sudo apt install mesa-opencl-icd ocl-icd-opencl-dev
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev
sudo apt install llvm
sudo apt install clang
curl https://sh.rustup.rs -sSf | sh

## 下载release包，运行
下载链接:
https://github.com/filecoin-project/lotus/releases/download/v1.1.2/lotus_v1.1.2_linux-amd64.tar.gz
tar zxvf lotus_v1.1.2_linux-amd64.tar.gz
cd lotus && cp -rp lotus* /usr/local/bin/

## 设置环境变量  vi /etc/profile
export SSD_PATH=/data1ssd
export LOTUS_PATH="$SSD_PATH/lotus-data/"
export LOTUS_MINER_PATH="$SSD_PATH/lotus_miner-data/"
export LOTUS_STORAGE_PATH="$SSD_PATH/lotusstorage"
export WORKER_PATH="$SSD_PATH/lotusworker"
export FIL_PROOFS_PARAMETER_CACHE="$SSD_PATH/filecoin-proof-parameters"
export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
export RUST_LOG=Trace
export FIL_PROOFS_MAXIMIZE_CACHING=1

## 手动下载零知识证明参数到FIL_PROOFS_PARAMETER_CACHE目录中，有200GB
lotus fetch-params 32GiB

## 启动lotus
lotus daemon
nohup lotus daemon > ~/lotus.log 2>&1 &

## 查看日志 tail -f ~/lotus.log


## For mainnet only:  #首次运行
lotus daemon --import-snapshot https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car
lotus daemon --import-snapshot minimal_finality_stateroots_latest.car
下载：
wget -c https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car --no-check-certificate



[0] 0:bash*                    

lotus wallet new bls
lotus wallet export f3xxxx  #备份钱包
lotus sync wait
lotus-miner init --owner=f0xxxx --sector-size=32GiB

##  命令
lotus daemon
lotus daemon stop   #停止
lotus net peers
lotus wallet list
lotus wallet new bls  #生成钱包地址
lotus wallet balance
lotus wallet export f3xxxx
lotus send <target address> <FIL_amount>
lotus send --from=<sender address> <target address> <FIL_amount>
lotus wallet export <address> > wallet.private
lotus sync status
lotus sync wait
date -d @$(lotus chain getblock $(lotus chain head) | jq .Timestamp)   #显示最后一个同步块的出块时间


lotus-miner run
lotus-miner info    #查看挖矿钱包


新建钱包地址：
f3tdf3fzjvsd26nkleykercmc4jji3zt4bakndxeq4ylpaiy7nzdsbw7xoitex4jfl6dj3yvmxftjhfwkjluhq
f3vfouyiwskkcjy2hncmexdyjv36tyaukcrdbtz6uc7wm2tdrooxwrnjmhi6d5yi3xotlgadragte5csh5zdcq
f3rnlpojlj54h2ps5usfno5x4dyi33tvm3eqilzhh7v4bfhh35obdimp2y437yln3rjz3t6qcqfohla777yj2q


lotus-miner init --owner=f3rnlpojlj54h2ps5usfno5x4dyi33tvm3eqilzhh7v4bfhh35obdimp2y437yln3rjz3t6qcqfohla777yj2q  --worker=f3vfouyiwskkcjy2hncmexdyjv36tyaukcrdbtz6uc7wm2tdrooxwrnjmhi6d5yi3xotlgadragte5csh5zdcq --no-local-storage




