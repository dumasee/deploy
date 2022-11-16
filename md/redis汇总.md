## redis 安装 
1. 安装
```
apt-get install redis-server
```

2. 改配置
```
vi /etc/redis/redis.conf
#bind 127.0.0.1   #注释掉
```

3. 重启
```
service redis-server restart
```

## redis 编译安装
1. 安装编译环境
```
apt-get update && apt-get upgrade
apt-get install build-essential
```

2. 编译安装
```
cd /mlc/redis-4.0.9/
make MALLOC=libc  #针对报错：recipe for target 'adlist.o' failed
make install
```


## redis 客户端连接
```
root@myServer001-lab:~# redis-cli 
127.0.0.1:6379> auth "你的密码"   #如果设置了密码
OK

redis-cli -p 6381
```

## redis 操作命令 
```
127.0.0.1:6379> SET color blue
OK
127.0.0.1:6379> SET color red
OK
127.0.0.1:6379> TYPE color
string
127.0.0.1:6379> GET color
"red"
```

## redis命令
```
flushall   #清缓存
redis-cli  #查看版本
```