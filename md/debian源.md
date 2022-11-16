## apt源路径
```
/etc/apt/sources.list   
```

## debian版本
lsb_release -a  #查询debian/ubuntu/centos版本及代号
```
debian 11 Bullseye
Debian 10 Buster  （4.19）
Debian 9 stretch  （内核版本4.9）
Debian 8 Jessie   （内核版本3.16）
7.0.0 to ... (Wheezy)
6.0.0 to ... (Squeeze)
5.0.0 to 5.0.10 (Lenny)
4.0_r0 to 4.0_r9 (Etch)
3.1_r0 to 3.1_r8 (Sarge)
3.0_r0 to 3.0_r6 (Woody)
```


## debian官方源
```
deb http://archive.debian.org/debian/ lenny contrib main non-free
该源保留了所有老发行版的软件包
```

## debian10 源
```
deb http://mirrors.aliyun.com/debian buster main contrib non-free
deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free
deb http://mirrors.aliyun.com/debian-security buster/updates main contrib non-free
deb http://mirrors.aliyun.com/debian/ buster-backports main contrib non-free
```

##  ubuntu版本
```
20.04 LTS  Focal  （内核版本5.4.0-66）  <-> LinuxMint20
18.04 LTS  bionic （内核版本4.15） <-> LinuxMint19
16.04 LTS  xenial （内核版本4.4） <-> LinuxMint18
14.04 LTS  Trusty Tahr	2014/04/18
12.04 LTS  Precise Pangolin 2012/04/26
```

## ubuntu18.04lts源 阿里云
```
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

