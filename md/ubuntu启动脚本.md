
## 登录脚本
/etc/profile 或 /etc/profile.d/
登录shell的时候会自动执行。一般用来配置环境变量。

链接：
https://blog.csdn.net/a308601801/article/details/86599512


## 开机启动脚本 未测试成功！

cp route_add.sh /etc/init.d/
cd /etc/init.d/
update-rc.d route_add.sh defaults 100   #数字越大  执行越晚  范围是0-100 

update-rc.d -f route_add.sh remove