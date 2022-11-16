
## 启用vpn
mkdir v2ray
cd v2ray
wget -c 192.168.11.6:3080/linux/v2ray-linux-64.zip
wget -c 192.168.22.9:3080/linux/v2ray-linux-64.zip
wget -c 111.0.121.226:3080/linux/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
导入config文件
nohup ./v2ray &

## 验证socks5
curl --socks5 127.0.0.1:10808 myip.ipip.net
curl --socks5 10.11.0.81:10808 myip.ipip.net

## 验证http代理
curl -x 127.0.0.1:10809 myip.ipip.net
curl -x 127.0.0.1:10809 cip.cc
curl -x 127.0.0.1:10809 ipinfo.io
curl -x 127.0.0.1:10809 icanhazip.com

## 全局启用http代理
- 设置环境变量：（重启或退出登录即失效。）
export http_proxy=127.0.0.1:10809 && export https_proxy=127.0.0.1:10809
export http_proxy=192.168.21.9:10809 && export https_proxy=192.168.21.9:10809
export http_proxy=192.168.22.9:10809 && export https_proxy=192.168.22.9:10809

## 测试验证
curl myip.ipip.net 



## tinyproxy
- 服务端配置
apt-get install tinyproxy
vi /etc/tinyproxy/tinyproxy.conf ，注释掉192.168.0.0/16这个网段。
DisableViaHeader Yes

/etc/init.d/tinyproxy restart

