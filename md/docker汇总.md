
## 官方脚本安装
```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```
说明：centos7启动docker失败：
处理方法：yum update

## docker for desktop
```
https://www.docker.com/products/docker-desktop
```

## docker命令
镜像
```
docker search IMAGE_NAME  #查找镜像
docker image pull IMAGE_NAME   #获取镜像
docker image ls   #列出本地镜像
docker image rm IMAGE_ID   #删除镜像，镜像id只需要输入前4位字符即可
docker image inspect mongo:latest | grep -i version  #查看镜像版本
docker save sonatype/nexus3:3.26.1 | gzip > image_nexus3_3.26.1.tar.gz   #将镜像保存为文件
docker load < image_nexus3_3.26.1.tar.gz   #从文件恢复镜像
```

容器
```
docker stop CONTAINER_ID  #停止容器
docker start CONTAINER_ID  #启动容器
docker restart CONTAINER_ID  #重启容器
docker exec jms6 ip add   #进入容器并执行命令
docker cp 16a3:/root/jumpserver_all.sql ./   #copy容器内文件
docker inspect 容器id/image   #查看容器详细信息
docker ps
docker ps -a  #显示所有容器，包括已退出的
docker rm CONTAINER_ID  #删除容器，容器id只需要输入前4位字符即可
docker stop fe32 && docker rm fe32    #停止并删除容器
docker stop $(docker container ls -a -q)   #停止所有容器
docker rm $(docker container ls -a -q)   #删除所有容器
docker volume ls  #查看所有数据卷
docker volume prune    #删除所有不被使用的数据卷
docker logs CONTAINER_ID -f  #看日志
```

## 容器示例
创建并启动容器，镜像为nginx，自动pull镜像到本地。
nginx对外暴露端口8080
1. 运行容器
```
docker run --name webserver_1 -d -p 8080:80 nginx  
```
2. 进入容器
```
docker exec -it 容器名字|容器ID bash
```

## 获取某个容器的ip地址
说明：若是host模式则输出为空。
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' CONTAINER_ID
```

## 显示所有容器ip地址
```
docker inspect --format='{{.Name}} - {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
```

## 查看docker网络
```
docker network ls
apt-get install bridge-utils
brctl  show
docker network inspect bridge    #查看bridge 网络的详细信息
```

## docker 存储路径
```
root@server005:/var/lib/docker/overlay2# du -h --max-depth=1 | wc
     30      60    2037
```

## 查看docker run启动参数
```
apt install -y python-pip
pip install runlike
runlike -p xxx
```

## 定制镜像
1. 创建Dockerfile
```
vi /root/mynginx/Dockerfile
FROM ubuntu:18.04
RUN echo '<h1> HeLLo, Docker!!!</h1>' > /usr/share/nginx/html/index.html
```
2. 构建镜像
```
docker build -t nginx:v7  /root/mynginx/
docker run -it myubuntu:v1 bash
```
在默认情况下，如果不额外指定 Dockerfile 的话，会将上下文目录下的名为 Dockerfile 的文件作为 Dockerfile
可以用 -f 参数指定某个文件作为 Dockerfile

3. 创建&启动容器
```
docker run --name webserver_1 -d -p 8080:80 nginx:v7
```

## docker-compose 
1. 更改默认python
```
rm -rf /usr/bin/python
ln -s /usr/bin/python3 /usr/bin/python
```

2. 安装docker-compose
```
apt-get install python3-pip
pip3 install docker-compose
```

## docker-pub 国内镜像仓库
http://hub-mirror.c.163.com
hub.c.163.com

Docker 官方中国区
https://registry.docker-cn.com

ustc
https://docker.mirrors.ustc.edu.cn