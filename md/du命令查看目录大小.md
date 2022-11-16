## 查看某个目录总和的大小
# du /var/lib/mysql -sh
441G    /var/lib/mysql


## 查看目录大小并按照大小倒序展示
du -h --max-depth=1 ./ | sort -hr 


## eb监控磁盘满清理
15 */8 * * * /usr/bin/echo > /opt/eb_admin/nohup.out
25 */12 * * * /usr/bin/echo > /opt/eb_portal/nohup.out