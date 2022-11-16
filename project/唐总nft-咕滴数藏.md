## 说明
参照四海一家的部署。  
不要参考万维 或者 国铁的！个别端口号规划不一样。  

域名： gudii.art  


## 下载部署
1. 前端  
```
cd /home/gudi
scp -P 10022 jumper@111.0.121.226:/home/jumper/apph5-digu.zip ./
unzip apph5-digu.zip 
mv h5 apph5

scp -P 10022 jumper@111.0.121.226:/home/jumper/webadmin-digu.zip ./
unzip webadmin-digu.zip 
mv dist admin
```

2. 后端  
```
cd /opt/gudi/portal
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-digital-gudi-1.0.0.jar ./

cd /opt/gudi/admin
scp -P 10022 jumper@111.0.121.226:/home/jumper/yb-admin-gudi-1.0.0.jar ./
```