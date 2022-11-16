一、环境配置：4台主机，3个ZK，4个kafka,3个orderer,2个ca,3个couchdb.2个组织，3个peer。(zk节点数应该为单数，kafka节点数应该为双数)
```
192.168.12.23：zookeeper0、kafka0、orderer0
192.168.12.24：zookeeper1、kafka1、orderer1、peer0.org1、ca0、couchdb0
192.168.12.29：zookeeper2、kafka2、orderer2、peer1.org1、couchdb1
192.168.12.30：kafka3、peer0.org2、ca1、couchdb2
```
二、软件安装：
  1、版本依赖：
  ```
    node必须为8.11以上的8.X版本，可以用8.16.2
    python必须为2.7版本
    go版本必须是1.11以上,目前使用1.13.4
    docker-compose:1.25以上，
```
  2、关闭防火墙
  ```
    firewall-cmd --state  #查看防火墙状态
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    service docker restart    #如果docker已安装，必须重启docker
```
  3、安装curl:
  ```
    sudo apt-get install openssl
    sudo apt-get install libssl-dev
    sudo apt-get update
    sudo apt-get install gcc make g++
    cd \home\
    wget https://curl.haxx.se/download/curl-7.67.0.tar.gz
    cd curl-7.67.0
    ./configure
    如果配置出错执行 ./configure --disable-dependency-tracking
    make && make install
    然后在$path中添加对应路径
    vi /etc/profile
    export LD_LIBRARY_PATH=/usr/local/lib
    退出，执行source /etc/profile
    检查是否成功：
    curl --version
```
  4、安装Go
  ```
    从https:golang.google.cn/dl/下载对应的软件包到\home\目录
    解压到/usr/local
    tar -xvf go1.13.4.linux-amd64.tar.gz -C /usr/local/
    设置Go对应的环境变量
    sudo vim /etc/profile
    export GOROOT=/usr/local/go
    export GOPATH=/home/go
    export PATH=$PATH:$GOROOT/bin:/$GOPATH/bin
```
  5、Docker安装
  ```
    sudo apt-get update
    sudo apt-get install  apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
```
  6、DockerCompose安装
  ```
    curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
```
  7、Nodejs安装
  ```
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh >> install.sh
    修改里面的安装路径 $HOME/.nvm 为/home/.nvm,防止其它用户无法访问root用户目录组产生问题。
    bash install.sh
    source /.bashrc  (最好把node相关变量也写到/et/profile里)
    nvm ls-remote
    nvm install 8.16.2
```
  8、Python安装
  ```
    sudo apt-get install python
```
    检查 python是否为2.7
三、编译Fabric版本
  下载fabric版本到 /home/go/src/github.com/hyperledger目录下，进入fabric,切换版本到v1.4.3
  ```
  git checkout -b v1.4.3 v1.4.3
  make release
  ```
  把release/linux-amd64/bin目录下文件复制到$GOPATH/bin下。
  检查每个命令的版本是否为1.4.3
  ```
  peer version
  ```
四、搭建Docker环境
  1、在自己工程路径创建kafka_cluster目录作为工程目录（可以是任意路径,目录名也可自定）
  ```
    root@192-168-12-23:/home/go/src/github.com/hyperledger#mkdir kafka_cluster && cd kafka_cluster
	```
  2、编写 crypto-config.yaml 和 configtx.yaml 配置文件，分别用于生成证书和通道配置信息，格式见模板文件
  3、创建私钥和证书文件
  ```
    cryptogen generate --config=./crypto-config.yaml
	```
  4、生成创世区块及通道配置区块
  ```
    mkdir channel-artifacts
    configtxgen -channelID kafka-channel -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
	```
  5、使用 configtxgen 生成创世区块
  ```
    configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
```
  6、生成peer的锚点文件
  ```
    configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
    configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
```
  7、将目录中所有文件拷贝到其它节点同级目录
  ```
    cd ..
    scp -r kafka_cluster root@192.168.12.24:/home/go/src/github.com/hyperledger
```
  8、编写各个服务器上的docker-compose-up.yaml文件
五、运行环境
  1、在4台服务器对应目录下启动docker-compose
    docker-compose -f docker-compose-up.yaml up -d
  2、启动成功后对照第一点环境检查各服务器里的docker进程是否正确
  3、在第二台带cli的节点进入容器，创建通道
  ```
    docker exec -it cli bash
    peer channel create -o orderer0.example.com:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```
    创建成功后会在当前目录生成 mychannel.block 文件。
  4、加入通道
  ```
    peer channel join -b mychannel.block
```
  5、更新锚节点：
  ```
    peer channel update -o orderer0.example.com:7050 -c mychannel -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```
  5、退出cli,将mychannel.block通道文件复制到宿主机
  ```
    docker cp 32fbbf20c9df:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block ./
```
  6、传送到另外两台带节点的服务器,并在对应的cli里加入到通道
  ```
    scp -r mychannel.block root@192.168.12.29:/home/go/src/github.com/hyperledger/kafka_cluster/
   29：
    docker cp mychannel.block 32fbbf20c9df:/opt/gopath/src/github.com/hyperledger/fabric/peer
    docker exec -it cli bash
    peer channel join -b mychannel.block
    进入docker后若未在当前目录下找到mychannel.block在其它目录下查找一下。
    另一台也执行相应命令，并更新锚节点(因为是组织的第一个节点)
    peer channel update -o orderer0.example.com:7050 -c mychannel -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```
六、链码部署、调用：
  1、回到第二台，工程路径创建链码目录,拷贝链码文件到链码目录的go目录下
  ```
    /home/go/src/github.com/hyperledger/kafka_cluster#mkdir -p chaincode/go
    /home/go/src/github.com/hyperledger/kafka_cluster# tree chaincode
chaincode
└── go
    └── chaincode_example02
        └── chaincode_example02.go
```
  2、回到kafka_cluster目录，进入容器
  ```
    docker exec -it cli bash
```
  3、安装链码
  ```
    peer chaincode install -n mycc -p github.com/hyperledger/fabric/kafka/chaincode/go/example02/  -v 1.0
```
  4、初始化链码
  ```
    peer chaincode instantiate -o orderer0.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem  -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a","200","b","400"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')"
```
    相应参数可执行peer chaincode instantiate --help 查询
  5、链码调用 ：
    查询账户余额
```
    peer chaincode query -C mychannel -n mycc -c ‘{“Args”:[“query”,“a”]}’
```
    转账交易
```
    peer chaincode invoke --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n mycc -c ‘{“Args”:[“invoke”,“a”,“b”,“20”]}’
```
    转账成功后再次查询余额是否有变动。
  6、在其它两个节点操作需要安装链码，不需要初始化链码
  ```
    docker exec -it cli bash
    peer chaincode install -n mycc -p github.com/hyperledger/fabric/kafka/chaincode/go/example02/  -v 1.0
```
  7、查询余额和调用转账，查看三个节点数据是否同步。