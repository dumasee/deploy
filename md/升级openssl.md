## 升级openssl

一、查看当前安装的版本
```
root@worker2723:~# cat /etc/issue
Ubuntu 18.04.5 LTS \n \l
root@worker2723:~# openssl version
OpenSSL 1.1.1  11 Sep 2018
```
注意：不要卸载旧版本，会出依赖方面的问题！

二、下载
```
cd /root/
wget -c https://www.openssl.org/source/openssl-1.1.1n.tar.gz
```

三、编译安装
```
tar zxvf openssl-1.1.1n.tar.gz
cd openssl-1.1.1n
./config
make 
make install
```
说明：make过程时间较长。

四、拷贝链接库
```
cd openssl-1.1.1n
cp libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/
cp libssl.so.1.1 /usr/lib/x86_64-linux-gnu/
```


五、建立软链接
```
mv /usr/bin/openssl /usr/bin/openssl.bak
ln -s /usr/local/bin/openssl /usr/bin/openssl
```

六、结果验证
```
root@worker2723:~# openssl version
OpenSSL 1.1.1n  15 Mar 2022
```