
## 安装 certbot
```
apt install certbot -y
```

## 通配符证书
```
readonly server='https://acme-v02.api.letsencrypt.org/directory'

certbot certonly -d demeter2.space -d *.demeter2.space --manual --preferred-challenges dns --server $server
certbot certonly -d bitmoney.shop -d *.bitmoney.shop --manual --preferred-challenges dns --server $server
certbot certonly -d ebkeji.com -d *.ebkeji.com --manual --preferred-challenges dns --server $server
certbot certonly -d wanwei.online -d *.wanwei.online --manual --preferred-challenges dns --server $server
certbot certonly -d qingdoumeta.com -d *.qingdoumeta.com --manual --preferred-challenges dns --server $server
```
提示需要在域名管理界面添加两条txt记录后，再回车。  

## 证书续期
```
certbot certificates    
certbot renew --dry-run
certbot renew
```

   
## 证书路径
```
/etc/letsencrypt/live/demeter2.space/fullchain.pem
/etc/letsencrypt/live/demeter2.space/privkey.pem

/etc/letsencrypt/live/ebkeji.com/fullchain.pem
/etc/letsencrypt/live/ebkeji.com/privkey.pem

/etc/letsencrypt/live/wanwei.online/fullchain.pem
/etc/letsencrypt/live/wanwei.online/privkey.pem
```