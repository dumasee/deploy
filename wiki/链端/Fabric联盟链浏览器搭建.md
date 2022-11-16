 本文档涉及的步骤是fabric浏览器的搭建部分，浏览器连接的节点的搭建参考节点搭建文档。
一、软件安装
  1、节点需要的软件包安装，参考节点搭建文档。
  2、安装Postgresql.
```
    apt install postgresql
```
  3、安装JQ
 ```
    apt install jq
```
二、浏览器下载及配置
  1、下载代码
  ```
    cd /home/go/src/github.com/hyperledger
    git clone https://github.com/hyperledger/blockchain-explorer.git
    cd blockchain-explorer
    git tag 查看版本
    git checkout -b v0.3.9.5 v0.3.9.5
```
  2、创建postgres数据库
```
    cd app/persistence/fabric/postgreSQL
    chmod -R 775 db
    cd db
    ./createdb.sh
    设置数据库远程访问功能：
    vi /etc/postgresql/9.5/main/postgresql.conf
    把listen_addresses='localhost’修改为listen_addresses = '*'
    vi /etc/postgresql/9.5/main/pg_hba.conf
    查看host配置项修改ip和端口号为如下：
    host    all             all             0.0.0.0/0                  md5
```
  3、修改配置config.json
    返回blockchain-explore目录，
```
    cd app/platform/fabric
    vi config.json
```
    修改network-configs里的配置项和名称为节点上使用的网络(docker network ls可以查看)
    修改profile对应的文件（可使用网络名修改connection-profile目录里的文件名）
  4、修改connection-profile里的json配置
    接上步profile配置的文件打开connect-profile里对应的json文件，
    修改name为网络名，
    重新配置adminPrivateKey,signedCert,tlsCACerts里的目录名称，修改adminPrivateKey里对应的私钥文件为实际目录下的文件。
    检查是否开启了tls，如未开启tls,需要把文件中tlsEnable设为false,并把grpcs改为grpc.
    保存，退出
  5、映射IP路由
    vi /etc/hosts
    把网络中orderer节点对应的域名和ip地址添加进去。
  6、回到blockchain-explorer目录，调用 main.sh install 安装程序依赖的node 包,注意node版本号使用8.11以上的8.X版本，(环境是8.16.2)，

  7、修改start.sh
 ```
    把export DISCOVERY_AS_LOCALHOST=true改成
    export DISCOVERY_AS_LOCALHOST=false
```
三、启动浏览器，打开网页查看：
    调用 ./start.sh启动浏览器服务进程，查看对应日志是否有报错。
    打开浏览器查看网页是否能正常开启。http:192.168.12.31:8080/

    清除中间数据：调用./stop.sh关闭后可以清除wallet目录下内容，重新调用 app/persistence/fabric/postgreSQL/db/createdb.sh清空数据库。