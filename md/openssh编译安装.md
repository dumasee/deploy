
##  升级 openssl  
一、查看当前安装的版本
```
# openssl version
OpenSSL 1.0.2g  1 Mar 2016
```
注意：不要卸载旧版本，会出依赖方面的问题！

二、下载
```
wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz
```

三、编译
```
tar zxvf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g && ./config --prefix=/usr/local/ssl shared  && make && make install
```
编译安装需较长时间!!!
说明：一定要加上shared 参数，要不在安装openssh的时候提示无法找到路径！

四、建立软链接
```
mv /usr/bin/openssl /usr/bin/openssl.bak
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/bin/openssl /usr/local/bin/openssl    #仅适用Centos6
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
```

五、结果验证
```
#openssl version
OpenSSL 1.1.1g  21 Apr 2020
```

##  升级 openssh  
一、查看当前版本
```
#ssh -V
OpenSSH_7.2p2 Ubuntu-4ubuntu2.8, OpenSSL 1.0.2g  1 Mar 2016
```

二、下载
```
wget -c https://ftp.riken.jp/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz
```

三、编译
```
tar zxvf openssh-8.3p1.tar.gz
cd openssh-8.3p1
./configure  --prefix=/usr --sysconfdir=/etc/ssh --with-ssl-dir=/usr/local/ssl --with-pam && make && make install
```
个别情况下需要加以下参数编译通过：--without-openssl-header-check

四、版本验证
```
#ssh -V
OpenSSH_8.3p1, OpenSSL 1.1.1g  21 Apr 2020
```

五、启动
```
cp /root/openssh-8.3p1/opensshd.init /etc/init.d/ssh
/etc/init.d/ssh restart
```

##  报错及处理
1. 报错一(debian9编译openssl)：
```
root@192-168-11-6:~# ldd /usr/local/ssl/bin/openssl
/usr/local/ssl/bin/openssl: /usr/lib/x86_64-linux-gnu/libssl.so.1.1: version `OPENSSL_1_1_1' not found (required by /usr/local/ssl/bin/openssl)
/usr/local/ssl/bin/openssl: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1: version `OPENSSL_1_1_1' not found (required by /usr/local/ssl/bin/openssl)
        linux-vdso.so.1 (0x00007ffdd3320000)
        libssl.so.1.1 => /usr/lib/x86_64-linux-gnu/libssl.so.1.1 (0x00007febcb923000)
        libcrypto.so.1.1 => /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 (0x00007febcb48a000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007febcb286000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007febcb069000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007febcacca000)
        /lib64/ld-linux-x86-64.so.2 (0x00007febcbe47000)
root@192-168-11-6:~#
```

2. 报错二(ubuntu)：
```
#openssl version
openssl: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
```

3. 报错三(ubuntu18.04)
```
root@jumper:~# openssl version
openssl: relocation error: openssl: symbol EVP_mdc2 version OPENSSL_1_1_0 not defined in file libcrypto.so.1.1 with link time reference
```

1&2&3处理方法：
```
cd openssl-1.1.1d
cp libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/
cp libssl.so.1.1 /usr/lib/x86_64-linux-gnu/
```

4. 报错四：configure: error: *** zlib.h missing
处理方法：
```
apt-get install zlib1g-dev  #for ubuntu/debian
yum install zlib-devel     #for centos
```

5. 报错五：configure: error: PAM headers not found
```
apt-get install libpam0g-dev  #for ubuntu/debian
yum -y install pam-devel     #for centos: 
```
6. 报错六：configure: error: Your OpenSSL headers do not match your library     #Debian9
添加参数后可以编译通过。
```
./configure --without-openssl-header-check
```

7. 安装后启动sshd报错
```
/etc/ssh/sshd_config line 16: Deprecated option UsePrivilegeSeparation
/etc/ssh/sshd_config line 19: Deprecated option KeyRegenerationInterval
/etc/ssh/sshd_config line 20: Deprecated option ServerKeyBits
/etc/ssh/sshd_config line 31: Deprecated option RSAAuthentication
/etc/ssh/sshd_config line 38: Deprecated option RhostsRSAAuthentication
```
处理方法：
编辑配置文件，将相应行注释掉。