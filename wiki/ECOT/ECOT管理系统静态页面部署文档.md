## 所需文件
  前端静态文件压缩包
## 安装步骤
1. 搭建服务器环境
服务器上安装nginx环境
2. 部署前端页面
上传压缩包到/var/www/html目录下，解压文件到当前目录，找到login.html文件，修改`/etc/nginx/site-enabled/defyult`中的root路径为login.html文件的上级目录，执行`serivce nginx restart`，通过http:ip:80端口访问页面