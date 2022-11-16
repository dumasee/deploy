
## jumpserver 安装
一、安装docker
使用官方脚本自动安装：
```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

二、拉取jumperserver镜像
```
docker pull jumpserver/jms_all:v2.4.3   
```
注：低版本迁移至2.5.x版本，会导致不能使用！！！
生产环境使用版本v2.4.3，后面新版本升级出问题，所以一直使用老版本至今。

三、启动容器
```
docker run --name jms1 -d -p 3080:80 -p 3022:2222   \
  -v /opt/jumpserver/data:/opt/jumpserver/data \
  -v /opt/jumpserver/mysql:/var/lib/mysql \
  jumpserver/jms_all:v2.4.3
```

四、浏览器登录
浏览器打开：
```
http://IP:3080
```

五、ssh连接
```
ssh admin@IP -p3022
```

六、镜像备份
```
docker save jumpserver/jms_all:v2.4.3 |gzip > image_jumpserver_v2.4.3.tar.gz    #备份镜像
docker load < image_jumpserver_v2.4.3.tar.gz   #导入镜像
```

## jumpserver 升级/备份恢复
```
mkdir /opt/jumpserver
docker cp jms1:/opt/jumpserver/data /opt/jumpserver/data
docker cp jms1:/var/lib/mysql /opt/jumpserver/mysql
chown -R 27:27 /opt/jumpserver/mysql

[root@131448863ce6 opt]# echo $SECRET_KEY
kWQdmdCQKjaWlHYpPhkNQDkfaRulM6YnHctsHLlSPs8287o2kW
[root@131448863ce6 opt]# echo $BOOTSTRAP_TOKEN
KXOeyNgDeTdpeu9q
[root@131448863ce6 opt]#


docker run --name jms1 -d \
  -v /opt/jumpserver/data:/opt/jumpserver/data \
  -v /opt/jumpserver/mysql:/var/lib/mysql \
  -p 3080:80 \
  -p 3022:2222 \
  -e SECRET_KEY=kWQdmdCQKjaWlHYpPhkNQDkfaRulM6YnHctsHLlSPs8287o2kW \
  -e BOOTSTRAP_TOKEN=KXOeyNgDeTdpeu9q \
  jumpserver/jms_all:v2.4.3
```

## 定期备份
```
cd /opt/
tar zcvf jumpserver_2022.03.28.tar.gz jumpserver/
rsync -av --progress -e 'ssh -p 10022' jumpserver_2022.03.28.tar.gz root@111.0.121.226:/root/
```

## jumpserver使用 
仪表盘->用户管理：（这里的用户是用于登录jumpserver的）
系统默认的管理员用户为admin，用户组为Default。根据需要新建用户及用户组。（系统缺省管理员帐号密码为admin/admin）
新建用户，选择禁用MFA，角色选择用户。

仪表盘->资产管理：（这里的用户是堡垒机登录资产用的。用户使用自己的用户名登录Jumpserver, Jumpserver使用系统用户登录资产）
管理用户：一般为root，指定ssh私钥
系统用户：一般为root，指定ssh私钥，登录模式为自动登录，勾选自动推送。也可以指定非root帐号，选中“自动生成密钥”，由jms自动推送在资产上创建帐号，Sudo项设置改为ALL实现免密执行sudo。【经测试若指定非root为系统用户，debian系统登录失败】
资产列表：资产需指定节点、管理用户名。

仪表盘->权限管理：
资产授权：自定义资产授权名称，指定用户组、节点、系统用户。


## 管理员密码恢复
admin帐号密码丢失/多因子验证失败等情况下，需要使用命令行创建管理员用户，进入容器操作。
```
source /opt/py3/bin/activate
cd /opt/jumpserver/apps
python manage.py createsuperuser --username=super1@gj --email=yank@eb-tech.cn
python manage.py changepassword  <user_name>
```
