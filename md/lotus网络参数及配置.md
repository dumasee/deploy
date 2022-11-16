
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [命令](#命令)
- [miner机网络配置](#miner机网络配置)
- [防火墙配置](#防火墙配置)

<!-- /code_chunk_output -->



## 命令
lotus net listen
```
/ip4/183.129.161.12/tcp/40903/p2p/12D3KooWAqRBTuAY6VCGqYzMJA2KvwabNvh3jVbfC5U7Muo3MxRW
/ip4/127.0.0.1/tcp/40903/p2p/12D3KooWAqRBTuAY6VCGqYzMJA2KvwabNvh3jVbfC5U7Muo3MxRW
```


lotus net reachability
```
AutoNAT status:  Public
Public address:  /ip4/183.129.161.12/tcp/40903
```


## miner机网络配置
- 防火墙做端口映射
- 更改lotus的配置文件，将AnnounceAddresses里边的公网地址改掉。

```
cd $LOTUS_PATH
vi config.toml

# Default config:
[API]
  ListenAddress = "/ip4/0.0.0.0/tcp/1234/http"

[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/37239"]
  AnnounceAddresses = ["/ip4/36.129.163.99/tcp/37239","/ip4/127.0.0.1/tcp/37239"]
```


## 防火墙配置
配置防火墙，映射lotus的1234端口及p2p端口
```
interface GigabitEthernet1/0/0
 port link-mode route
 description to_ISP
 combo enable copper
 ip address 183.129.161.12 255.255.255.224
 packet-filter 3001 inbound
 nat outbound 2001 address-group 1
 nat server protocol tcp global 183.129.161.12 1234 inside 192.168.23.31 1234 rule ServerRule_3
 nat server protocol tcp global 183.129.161.12 11234 inside 192.168.21.31 1234 rule ServerRule_12
 nat server protocol tcp global 183.129.161.12 21234 inside 192.168.21.32 1234 rule ServerRule_13
 nat server protocol tcp global 183.129.161.12 40657 inside 192.168.21.32 40657 rule ServerRule_4
 nat server protocol tcp global 183.129.161.12 40903 inside 192.168.23.31 40903 rule ServerRule_2
 nat server protocol tcp global 183.129.161.12 40905 inside 192.168.21.31 40905 rule ServerRule_10
 nat server protocol tcp global 183.129.161.12 40907 inside 192.168.24.31 40907 rule ServerRule_11
```


1234端口访问加白名单
```
acl advanced 3000
 description for_Server_Access
 rule 3 permit ip destination 47.99.129.32 0
 rule 11 permit tcp destination 47.98.155.42 0 source-port eq 1234
 rule 12 permit tcp destination 8.210.185.58 0 source-port eq 1234
 rule 13 permit tcp destination 8.136.125.147 0 source-port eq 1234
 rule 14 permit tcp destination 118.31.245.149 0 source-port eq 1234
 rule 15 permit tcp destination 47.100.203.24 0 source-port eq 1234
 rule 16 permit tcp destination 47.118.55.65 0 source-port eq 1234
 rule 17 permit tcp destination 111.0.121.226 0 source-port eq 1234
 rule 101 deny tcp source-port eq 22
 rule 103 deny tcp source-port eq 1234
 rule 1000 permit ip
```

接口配置
```
interface GigabitEthernet1/0/2
 port link-mode route
 ip address 10.0.0.2 255.255.255.252
 packet-filter 3000 inbound
#
interface GigabitEthernet1/0/3
 port link-mode route
 ip address 10.0.0.6 255.255.255.252
 packet-filter 3000 inbound
#
interface GigabitEthernet1/0/4
 port link-mode route
 ip address 192.168.21.2 255.255.255.0
 packet-filter 3000 inbound
#
interface GigabitEthernet1/0/5
 port link-mode route
 ip address 192.168.24.2 255.255.255.0
 packet-filter 3000 inbound
 ```


 ## 报错
 ```
 eb2@miner2432:~$ lotus-miner info
ERROR: could not get API info for FullNode: repo directory does not exist. Make sure your configuration is correct
```

处理方法：
```
vi .profile ， 添加环境变量：
export FULLNODE_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.cYctdyfPyyrWu0VYNcgfaS-kbpyRkKXCxvxon6HB8oU:/ip4/127.0.0.1/tcp/1234/http

source  .profile   #使环境变量生效。
```