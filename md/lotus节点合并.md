<!-- 更新日期：2022.11.08 -->

## 目的
lotus与miner节点通常位于一个服务器上，miner默认连接本机lotus节点。<br>
当本机lotus节点因某个原因不能正常提供连接，这时需要配置本机miner连接其它lotus节点。


## 步骤
1. 本机lotus节点私钥备份
2. 本机lotus节点私钥在其它lotus节点导入
3. 更改本机miner启动脚本，配置 `FULLNODE_API_INFO`，指向其它lotus节点。
4. 停止miner进程，并使用miner脚本重新启动进程。



## 参数确定方法
cd $LOTUS_PATH
```
token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.fyFwFc3PzWKooPlMAtH2tDf-qgXYS_s9UCmNElMdlQU
api=/ip4/0.0.0.0/tcp/1234/http
export FULLNODE_API_INFO=$token:$api
```


## 私钥备份与导入
1 本机节点 查询Owner及Worker地址
https://filfox.info

2 在本机节点上 导出私钥
```
root@miner2231:~# 
root@miner2231:~# lotus wallet export f3uci7elabavnvdlc6dgxkshvjodcw5wthnzfza6dhaj44ztpbrqws6gd5jqemhvjjqtujeqsaonmb4vryhe4a
7b2254797065223a22626c73222c22507269766174654b6579223a224b6f6745494f636a387350797a6b6a4f595a532f65327356643973644535467149795a7272713745756d513d227d
root@miner2231:~# lotus wallet export f3utmt7kqfv3zjt5ux5cv7gth6u5embjqsifjk5xjekfh6rfazq627uxw7qpnaxs2z4uw6qusiulxw5mwq6vfa
7b2254797065223a22626c73222c22507269766174654b6579223a224153464651345a446b7342492b6952636555416e6a717271456841652f746b6c4f5734664c78506b3632493d227d
root@miner2231:~# 
```


3 在其它lotus节点（被指向的节点，即对外暴露的daemon） 导入私钥
```
lotus wallet import
Enter private key:
```

## 加入环境变量
vi runminer.sh
```
……
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.X_EKJDxlojb5Fp4kKgyNyi9F7kB6QPgMaJL2tegS92M:/ip4/127.0.0.1/tcp/1234/http
……
```


## 节点连接参数
```
## 自建
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.bpsTC-OLIvreCAQcKzp8fekmZ7uMSI8BBhAIye-qvPc:/ip4/192.168.21.31/tcp/1234/http


## 测试机-miner2631
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.fyFwFc3PzWKooPlMAtH2tDf-qgXYS_s9UCmNElMdlQU:/ip4/192.168.21.33/tcp/1234/http


## 北京1-2232
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.Fb-xgXj6zLGwrDFcnrxyXKsvjKVHGz1A1_10L4ii1AE:/ip4/192.168.22.32/tcp/1234/http


#郁康
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.SFcPbz5YcVenLC1jyEyEvLBsFJO30H3poXVSYtqvBOc:/ip4/192.168.21.32/tcp/1234/http

## 云联储
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.LyHnfF9wCVhz6lbYalGvYiAp59HQdcJuKgp_cZYKNVc:/ip4/192.168.23.31/tcp/1234/http

## 杭州王磊
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.cYctdyfPyyrWu0VYNcgfaS-kbpyRkKXCxvxon6HB8oU:/ip4/192.168.24.32/tcp/1234/http


## 北京1
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.SFcPbz5YcVenLC1jyEyEvLBsFJO30H3poXVSYtqvBOc:/ip4/192.168.22.31/tcp/1234/http


## 鞍山1
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.ZYfRzwNyMwP2Yo26qJMWfp3PxNDzrBqWEY-9REXLP4k:/ip4/192.168.5.31/tcp/1234/http

## 鞍山2
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.X_EKJDxlojb5Fp4kKgyNyi9F7kB6QPgMaJL2tegS92M:/ip4/192.168.5.32/tcp/1234/http
```

