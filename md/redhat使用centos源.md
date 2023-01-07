
## RedHat6.5更换centOS源
1. 删除自带的源
```
rpm -aq | grep yum|xargs rpm -e --nodeps
```

2. 下载
```
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-3.2.29-73.el6.centos.noarch.rpm 
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.30-37.el6.noarch.rpm 
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
```

3. 安装
```
rpm -ivh yum-3.2.29-73.el6.centos.noarch.rpm yum-metadata-parser-1.1.2-16.el6.x86_64.rpm yum-plugin-fastestmirror-1.1.30-37.el6.noarch.rpm 
```

4. 更改配置
```
cd /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo


vim CentOS6-Base-163.repo
:%s/$releasever/7/g

yum clean all
yum makecache
```

5. redhat删除注册提示：
```
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
```

## 相关命令
```
#查找subscription-manager相关组件
rpm -qa|grep subscription-manager

#查找rhn相关组件
rpm -qa|grep rhn

#删除subscription-manager和rhn的相关程序组件
yum remove subscription-manager
yum remove rhn-check
```