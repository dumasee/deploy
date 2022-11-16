
## frp 部署
1. 下载
```
scp -P 10022 root@112.17.170.150:/root/file/frp_0.25.3_linux_amd64.tar.gz ./
tar zxvf frp_0.25.3_linux_amd64.tar.gz
cd frp_0.25.3_linux_amd64/
```

2. 服务端
- 配置
```
root@TEST:[/root/frp_0.25.3_linux_amd64]cat frps.ini
[common]
bind_port = 7000
token = &wyAnKJz5WHF
```

- 启动
```
./frps -c ./frps.ini
```

3. 客户端
- 配置
```
vi frpc.ini
[common]
server_addr = 101.37.30.2
server_port = 7000
admin_addr = 127.0.0.1
admin_port = 7400

[yapi]
type = tcp
local_ip = 192.168.12.17
local_port = 3000
remote_port = 3000
use_encryption = true

[道路监测]
type = tcp
local_ip = 192.168.13.18
local_port = 7788
remote_port = 3078
use_encryption = true

[socks5]
type = tcp
local_ip = 192.168.11.6
local_port = 1002
remote_port = 3002
use_encryption = true

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 3022
use_encryption = true
```

- 启动
```
./frpc -c ./frpc.ini
```

