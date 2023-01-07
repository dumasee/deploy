## ipfs 安装部署 
一、下载安装
```
https://dist.ipfs.io/go-ipfs/v0.7.0/go-ipfs_v0.7.0_linux-amd64.tar.gz
https://dist.ipfs.io/go-ipfs/v0.7.0/go-ipfs_v0.7.0_windows-amd64.zip

tar -zxvf go-ipfs_v0.4.18_linux-amd64.tar.gz
cd go-ipfs/
./install.sh
```

二、初始化
```
ipfs init
```

三、启动daemon
```
ipfs daemon &
```

四、web管理界面
```
http://127.0.0.1:5001/webui
```

##  ipfs 命令 
```
ipfs add <filePath>     #添加文件到ipfs网络
ipfs add -r <dirPath>   #添加目录到ipfs网络

ipfs get <hash>   #下载文件
ipfs cat <hash>   #查看文件内容
ipfs ls <hash>    #查看文件子块

ipfs pin add <hash>    #在本地持久化某个文件
ipfs pin ls    #查看哪些文件在本地是持久化的
ipfs pin rm -r <hash>  #解除pin锁定

ipfs id     #查看本节点信息，常用于诊断
ipfs swarm peers    #查看所有对等节点，常用于诊断
ipfs dht findprovs <hash>  #查找文件提供商
```

举例:
ipfs get QmUuYG4qx7fv3SdeWo7YjEzVrXTxseaNEDfqx1c3yBQAJP -o hong.pdf
