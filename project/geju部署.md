

## 部署
以四海一家的配置及脚本作为模板进行部署。  
shyj_thin.tar.gz

1. 前端
```
scp -P 10022 jumper@111.0.121.226:/home/jumper/apph5-geju.zip ./
scp -P 10022 jumper@111.0.121.226:/home/jumper/webadmin-geju.zip ./
```
2. 后端
```
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-admin-geju-1.0.0.jar ./
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-digital-geju-1.0.0.jar ./
```
3. 路径
```
/home/geju/apph5
/home/geju/webadmin

/opt/geju/portal
/opt/geju/admin
```

## 发布
- apph5
http://47.99.132.98 

- webadmin
http://47.99.132.98:8080

- api  
http://47.99.132.98:8081