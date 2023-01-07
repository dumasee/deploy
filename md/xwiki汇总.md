https://github.com/xwiki-contrib/docker-xwiki/blob/master/README.md

## 部署xwiki
1. 创建网桥
#说明：必须先创建专用网桥，否则docker跑起来后页面打不开。
```
docker network create -d bridge xwiki-nw
```

2. mysql 镜像拉取
```
docker pull 112.17.170.150:8083/mysql:5.7
```

3. mysql 运行容器
```
docker run --net=xwiki-nw --name mysql-xwiki -v /opt/xwiki/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=xwiki -e MYSQL_USER=xwiki -e MYSQL_PASSWORD=xwiki -e MYSQL_DATABASE=xwiki -d mysql:5.7 --character-set-server=utf8 --collation-server=utf8_bin --explicit-defaults-for-timestamp=1
```

4. xwiki镜像拉取，运行容器
#注意首次docker run之后，停止容器，然后再docker start
```
docker pull 112.17.170.150:8083/xwiki:11.10.10
docker run --net=xwiki-nw --name xwiki -p 8080:8080 -v /opt/xwiki/xwiki:/usr/local/xwiki -e DB_USER=xwiki -e DB_PASSWORD=xwiki -e DB_DATABASE=xwiki -e DB_HOST=mysql-xwiki xwiki:11.10.10
```


5. 开启管理员帐号
```
vi /opt/xwiki/xwiki/data/xwiki.cfg，
把“xwiki.superadminpassword=system”前注释去掉，用帐号superadmin/system登陆。
```

6. 离线安装基本插件
```
cd /data/xwiki/data/extension/repository
cp /root/xwiki-platform-distribution-flavor-xip-10.11.9.xip ./
mv xwiki-platform-distribution-flavor-xip-10.11.9.xip xwiki-platform-distribution-flavor-xip-10.11.9.zip
unzip xwiki-platform-distribution-flavor-xip-10.11.9.zip
```

## 可选插件
```
PDF Viewer Macro    #支持pdf附件内容显示，语法： {{pdfviewer file="onelogin-api-android.pdf" /}}
```

## 备份
```
docker部署，直接备份/opt/xwiki目录。
```
