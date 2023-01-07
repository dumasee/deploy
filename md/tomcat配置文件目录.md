## 根据端口号查找进程
```
  lsof -i:80
  ps -ef|grep 9298
  ```

## 步骤
1. 改配置
```
/data/iotcard/apache-tomcat-8.5.20/conf
vi web.xml
   <init-param>
            <param-name>listings</param-name>
            <param-value>true</param-value>   #将原配置的false改为true
   </init-param>
```

2. 改配置
```
/data/iotcard/apache-tomcat-8.5.20/conf/Catalina/localhost
vi download.xml
  <?xml version="1.0" encoding="UTF-8"?>
  <Context  path="/download" docBase="/data/iotcard/apache-tomcat-8.5.20/webapps/download" crossContext="true">
  </Context>
```
将文件oneLogin.zip传至目录下： /data/iotcard/apache-tomcat-8.5.20/webapps/download

3. 重启tomcat
```
/data/iotcard/apache-tomcat-8.5.20/bin
./shutdown.sh
./startup.sh
```
