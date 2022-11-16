## 链接
```
https://www.postgresql.org/download/linux/ubuntu/
```

## ubuntu/debian安装postgresql-14

1. 安装
```
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get -y install postgresql-14 
```
2. 初始化帐号密码
```
sudo -u postgres psql
postgres=# alter user postgres with password 'xxxxxxx';
```

3. 配置远程访问
```
vim /etc/postgresql/14/main/postgresql.conf
listen_addresses = '*'
password_encryption = scram-sha-256


vim /etc/postgresql/14/main/pg_hba.conf
host    all             all             0.0.0.0/0            scram-sha-256
```
4. 重启进程
```
/etc/init.d/postgresql restart
```

5. 登录
```
su - postgres
psql
```

## docker方式安装postgre
1. 拉镜像
```
docker pull postgres:14.3-alpine
```

2. 运行容器
docker on linux
```
docker run --name pg14 -p 15432:5432 -d \
  --restart=always \
  -v /opt/postgres/data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=xxxxxx \
  -e TZ=Asia/Shanghai \
  postgres:14.3-alpine
```
3. 登录
```
docker exec -it pg14 psql -U postgres
```

## postgre命令
- 基本操作
```
\l 查看当前的数据库列表
\conninfo 列出当前连接信息
\c 查看当前连接信息
\c xxx 连接数据库
\d 显示当前数据库下的所有表
\d xxx 列出指定表的所有字段
\d+ xxx 查看表创建信息
\q 退出
DROP database test1;  删除数据库
DROP TABLE test1;   删除表
drop user xxx;   删除用户
ALTER USER postgres WITH PASSWORD 'xxxxxx';   改密码。
SHOW TIMEZONE;  #显示当前时区
```

- 查询用户
```
select * from pg_user;
select * from information_schema.table_privileges where grantee='user1';
```

- 建立用户并授权
说明：grant命令需要切换到相应database下使用。
```
CREATE USER user1 PASSWORD 'User_123456';
grant select on all tables in schema public to user1;
```

- 回收用户权限
```
revoke select on all tables in schema public from user3;
```
## 备份/恢复
- 备份/恢复 单个数据库
pg_dump -h 127.0.0.1 -p 15432 --column-inserts -U postgres postgres > pg_dump-postgres.sql
psql -h 127.0.0.1 -p 15432 -U postgres postgres < pg_dump-postgres.sql


- 备份所有数据库
pg_dumpall可以备份所有数据库，并且备份角色、表空间。
```
pg_dumpall --column-inserts -U postgres  > pg_dumpall.sql
```

- 备份单个表
```
pg_dump --column-inserts -U postgres -t server_ecs postgres > pg_dump-server_ecs.sql
```


## 查询/更改序列号
- 查询当前序列号
```
SELECT last_value FROM public.server_vultr_id_seq;
```

- 更改序列号到指定值
```
SELECT pg_catalog.setval('public.server_vultr_id_seq', 4, true);
```

## 添加字段
```
alter table 表名 add COLUMN 字段x int ;
```

## 主键
关系数据库理论要求每一个表都要有一个主键。但PostgreSQL中并未强制要求这一点，但是最好能够遵循它。
不要使用日期或时间作为主键，应该使用自动递增的整型字段作为主键。
generated always as identity 系统会自动生成递增值，不需要手工指定，若手工指定值则会报错。
强烈建议使用always方式。

## 关于timestamp
select to_char(now(), 'yyyy-MM-dd HH24:mi:ss')
select ip, to_char(time, 'yyyy-MM-dd HH24:mi:ss') as time FROM server_ecs


## postgrest安装配置
0. 下载链接
```
https://github.com/PostgREST/postgrest/releases/download/v9.0.0.20220211/postgrest-v9.0.0.20220211-linux-static-x64.tar.xz
```

1. 配置文件
vi  cat db.conf 
```
db-anon-role = "postgres"
db-uri = "postgresql://postgres:${POSTGRES_PASSWORD}@127.0.0.1:15432"
server-host = "0.0.0.0"
server-port = 13000
```

2. 启动
```
ps aux|grep postgrest|grep -v grep || (cd /opt/pgrest && nohup ./postgrest db.conf 2>&1 > pgrest.log &)

```

3. 测试
```
curl -sL "http://127.0.0.1:13000/test1?select=account,name,owner"    #查询
curl -sL "http://127.0.0.1:13000/test1?account=eq.f01040516" -X DELETE    #删除
curl -sL "http://127.0.0.1:13000/server_ecs"   
```
4. 浏览器
http://127.0.0.1:13000/server_ecs

