## 参考
<FEN链部署文档.docx>

## 步骤
1. 下载  
```
wget -c 101.132.37.246:8000/fen.tar.gz
tar zxvf fen.tar.gz
```

2. 生成.fen目录  
```
cd /root/fen
./fend.sh
```

3. 编辑配置  
cd /root/.fen  
vi fen.conf  
```
rpcuser=user
rpcpassword=123456
rpcallowip=0.0.0.0/0
listen=1
server=1
rpcbind=0.0.0.0
addnode=172.30.173.169
addnode=172.30.173.170
```

4. 运行  
```
cd /root/fen/ && ./fend.sh -staking=1 -daemon -rpcthreads=100
```

5. 执行必要的指令   
生成新地址：  
```
./fen-cli.sh getnewaddress  
```
手动出块（需手动执行多次，直至挖矿开启。）  
<执行脚本即可：>   
```
for i in {1..35}
do
#/bin/sleep 1
./fen-cli.sh generate 100
echo
done
```

## 命令
- 查看节点信息
```
./fen-cli.sh getinfo
```
- 查看挖矿是否开启：  
```
./fen-cli.sh getstakinginfo
```