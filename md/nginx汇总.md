

##  nginx命令
```
nginx -s stop       快速关闭Nginx，可能不保存相关信息，并迅速终止web服务。
nginx -s quit       平稳关闭Nginx，保存相关信息，有安排的结束web服务。
nginx -s reload     因改变了Nginx相关配置，需要重新加载配置而重载。
nginx -s reopen     重新打开日志文件。
nginx -c filename   为 Nginx 指定一个配置文件，来代替缺省的。
nginx -t            不运行，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件。
nginx -v            显示 nginx 的版本。
nginx -V            显示 nginx 的版本，编译器版本和配置参数。
```

## docker 安装 nginx
1. 拉镜像
```
docker pull nginx:1.23-alpine
```
2. 启动
```
docker run --name nginx_1 -d --restart=always -p 13080:80 -v /opt/nginx/html:/usr/share/nginx/html:ro nginx:1.23-alpine
docker run --name nginx_1 -d --restart=always -p 3080:80 -v /mnt/nvme2:/usr/share/nginx/html:ro nginx:1.23-alpine
docker run --name nginx_1 -d --restart=always -p 3080:80 -v /opt/deploy:/usr/share/nginx/html:ro nginx:1.23-alpine
```

3. 配置
```
docker exec -it nginx sh
vi /etc/nginx/conf.d/default.conf
location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        charset utf-8;  #添加该行内容
        autoindex on;   #添加该行内容
}
```
##  nginx 负载均衡 
编辑配置文件  
vi /etc/nginx/sites-enabled/my_slb  
```
    upstream mySLB {
	  #ip_hash;
      server 127.0.0.1:8001 weight=2;
      server 127.0.0.1:8002 weight=3; 
      #server 192.168.111.104:8003 backup;
	  keepalive 20;
    }

server {
    listen       80;
    server_name  localhost;
	
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
		proxy_http_version 1.1;
		proxy_set_header Connection "";
	    proxy_pass http://mySLB; 
    }
}
```
说明：  
1、Nginx的upstream中，ip_hash和backup指令不能同时使用。  
2、测试命令：curl 127.0.0.1  
或者直接打开浏览器，输入nginx的ip地址测试。  

## nginx 启用目录浏览功能 
1. 添加配置  
vi /etc/nginx/sites-enabled/file_server  
```
server {
        listen       3080;
        #server_name ;
        #access_log  logs/host.access.log  main;
        location / {
           root   /opt/nginx/html;
           index  index.html index.htm;
           charset utf-8;
           autoindex on;
           autoindex_exact_size off;
           autoindex_localtime on;
       }
}
```

2. 配置目录权限  
```
chown -R www-data:www-data /opt/nginx/html
```
说明：配置文件属主及属组为www-data

## 压力测试工具：httperf
```
apt-get install httperf
httperf --client=0/1 --server=localhost --port=80 --uri=/ --send-buffer=4096 --recv-buffer=16384 --num-conns=1000 --num-calls=5 --timeout 5
```

## 压力测试工具：webbench 
1. 下载，安装
```
wget http://www.ha97.com/code/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make
make install
```
2. 测试命令
```
webbench -c 100 -t 10 http://localhost/
webbench -c 100 -t 10 http://192.168.101.58:5000/natmap
webbench -c 100 -t 10 http://192.168.101.58:8000/demo_pj/
webbench -c 100 -t 10 http://106.14.163.127:4082/#/pages/index/home
```
说明：  
1、优点：大概是用过的唯一能测出最大并发连接数的工具了。  
2、webbench 做压力测试时，该软件自身也会消耗CPU和内存资源，为了测试准确建议将webbench安装在别的服务器上。  



## 限制单个ip请求速率
vi /etc/nginx/sites-enabled/portal-api   
```
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=8r/s;
server {
    location / {
           limit_req zone=mylimit burst=10 nodelay;
    }
}
```

## 限制单个ip最大连接数
vi /etc/nginx/sites-enabled/portal-api   
```
limit_conn_zone $binary_remote_addr zone=oneip:10m;
limit_conn oneip 20; 
```
## 万维app查看连接的客户端ip
```
ss -nt|egrep ':4082|:8081'|awk '{print $5}'|awk -F: '{print $1}'|sort | uniq -c
```