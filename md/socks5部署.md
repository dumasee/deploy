https://hub.docker.com/r/lozyme/sockd

1. 拉取镜像
```
docker pull lozyme/sockd:latest
```

2. 运行容器
```
docker run -d \
    --name sockd \
    --publish 2020:2020 \
    --volume /opt/sockd/sockd.passwd:/home/danted/conf/sockd.passwd \
    lozyme/sockd
```

3. 添加用户
```
docker exec sockd script/pam show
docker exec sockd script/pam add socks5 Vqbw-DrS6O8M
```

4. 测试
```
curl -x socks5://127.0.0.1:2020 myip.ipip.net --proxy-user socks5:Vqbw-DrS6O8M
```