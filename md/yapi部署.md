## 步骤
1. 创建 MongoDB 数据卷
```
mkdir -p /opt/yapi/mongo
```

2. 启动 MongoDB
```
docker pull 112.17.170.150:8083/mongo:4.2.9
docker run -d -v /opt/yapi/mongo:/data/db --name mongo-yapi mongo:4.2.9
```

3. 获取 Yapi 镜像，
版本信息查看地址 https://dev.aliyun.com/detail.html?spm=5176.1972343.2.26.I97LV8&repoId=139034
```
docker pull registry.cn-hangzhou.aliyuncs.com/anoy/yapi     #版本1.8.5
```

4. 初始化 Yapi 数据库索引及管理员账号
```
docker run -it --rm \
  --link mongo-yapi:mongo \
  --entrypoint npm \
  --workdir /api/vendors \
  registry.cn-hangzhou.aliyuncs.com/anoy/yapi:latest \
  run install-server
```
初始化管理员账号成功,账号名：
"admin@admin.com"，密码："ymfe.org"


5. 启动 Yapi 服务
```
docker run -d \
  --name yapi \
  --link mongo-yapi:mongo \
  --workdir /api/vendors \
  -p 3000:3000 \
  registry.cn-hangzhou.aliyuncs.com/anoy/yapi:latest \
  server/app.js
```

6. 备份及恢复
- 备份导出，（备份脚本：bak_mongo.sh）
```
mongodump --host IP --port 端口 -u 用户名 -p 密码 -d 数据库 -o 文件路径
```
当前版本 版本: 1.8.5


- 恢复
```
docker cp 20201010_020001.tar.gz mongo-yapi:/root/   #提前将备份拷贝到docker
```
```
docker exec -it mongo-yapi bash
mongo
use yapi
db.dropDatabase()
show dbs
exit
cd /root/
tar -zxvf 20201010_020001.tar.gz -C ./    #解压备份文件
mongorestore -d yapi /root/20201010_020001/yapi/
```


## mongo命令
```
mongo  #连接db
show dbs   #查看所有数据库
use db_name  #使用数据库
db.dropDatabase() # 删除当前正在使用的数据库
db.version()
```

