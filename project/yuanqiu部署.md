
## 部署
以四海一家的配置及脚本作为模板进行部署。  
shyj_thin.tar.gz

1. 前端
```
scp -P 10022 jumper@111.0.121.226:/home/jumper/webadmin-yuanqiu.zip ./
scp -P 10022 jumper@111.0.121.226:/home/jumper/apph5-yuanqiu.zip ./
```
2. 后端
```
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-digital-yuanqiu-1.0.0.jar ./
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-admin-yuanqiu-1.0.0.jar ./
```
3. 路径
```
/home/yuanqiu/webadmin
/home/yuanqiu/apph5
/opt/yuanqiu/portal
/opt/yuanqiu/admin
```

## 发布
- apph5   
http://106.14.181.34

- webadmin  
http://106.14.181.34:8080

- api  
http://106.14.181.34:8081