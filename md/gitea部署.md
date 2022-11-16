## 链接
https://docs.gitea.io/zh-cn/


## 准备
1. 数据库   
准备一个数据库，例如：postgresql   
新建数据库：gitea    
数据库帐号：postgres   

2. 创建系统帐号  
gitea不能在root下运行，必须是普通用户权限。
```
useradd -d /home/git -s /bin/bash  -m git  
```

## 步骤
1. 下载并运行
```
su - git
cd /opt/git
wget -c https://dl.gitea.io/gitea/1.17.3/gitea-1.17.3-linux-amd64
nohup ./gitea-1.17.3-linux-amd64 &
```

2. 配置  
打开网页并配置相应参数。  
配置文件路径：`./custom/conf/app.ini`  
```
http://192.168.11.6:3000
```


3. git客户端操作  
```
git clone http://192.168.11.6:3000/ebdev/testrepo.git
```

4. 备份  
- 备份/恢复数据库
```
pg_dump -h 127.0.0.1 -p 15432 --column-inserts -U postgres gitea > pg_dump-gitea.sql
psql -h 127.0.0.1 -p 15432 -U postgres gitea < pg_dump-gitea.sql
```

- 备份程序目录  
```
路径：/mnt/data1/git
```
