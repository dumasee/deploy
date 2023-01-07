
## 添加配置
vi /etc/nginx/sites-enabled/mynginx
```
upstream myhttpserver{
    server 127.0.0.1:13080;
}

server {
         listen 80;
         server_name  blue.ebkeji.com;
         rewrite ^(.*)$ https://$host$1;
         location / {
             proxy_pass http://myhttpserver;
         }
     }

server {
         listen 443;   #Nginx 1.15.0以上版本请使用listen 443 ssl代替listen 443和ssl on。
         server_name blue.ebkeji.com; 
         root html;
         ssl on;
         index index.html index.htm;
         ssl_certificate /etc/letsencrypt/live/ebkeji.com/fullchain.pem;  
         ssl_certificate_key /etc/letsencrypt/live/ebkeji.com/privkey.pem; 
         ssl_session_timeout 5m;
         ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
         ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
         ssl_prefer_server_ciphers on;
         location / {
             proxy_pass http://myhttpserver;
           }
        }
```


## 重启nginx
```
/etc/init.d/nginx reload
```