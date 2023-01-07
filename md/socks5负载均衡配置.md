
1. 配置nginx
```
vi /etc/nginx/nginx.conf

stream {
    upstream local-proxy  {
        hash $remote_addr consistent;
        server 127.0.0.1:2001; 
        server 127.0.0.1:2002; 
        server 127.0.0.1:2003; 
        server 127.0.0.1:2004; 
    }
 
    server {
        listen 3001;
        proxy_pass local-proxy;
    }
}
nginx -s reload   #重新加载配置
```

2. 开启socks监听
```
ssh -qTfnND 127.0.0.1:2001 root@35.229.254.135 -p 22   #Google 台湾
ssh -qTfnND 127.0.0.1:2002 root@35.236.151.216 -p 22   #Google 台湾


添加crontab：
*/10 * * * * ps aux|grep 127.0.0.1:2001|grep -v grep || ssh -qTfnND 127.0.0.1:2001 root@35.229.254.135 -p 22
*/10 * * * * ps aux|grep 127.0.0.1:2002|grep -v grep || ssh -qTfnND 127.0.0.1:2002 root@35.236.151.216 -p 22
```

3. 测试
```
curl -x socks5://127.0.0.1:10808 http://icanhazip.com

curl --socks5 127.0.0.1:1080 http://icanhazip.com
curl --socks5 127.0.0.1:1081 http://icanhazip.com
curl --socks5 127.0.0.1:3001 http://icanhazip.com

curl --socks5 192.168.12.5:1080 http://icanhazip.com
curl --socks5 192.168.11.6:1002 http://icanhazip.com
```