<!--
2022.10.27
-->

## git命令
```
git checkout xxx   #切换分支，功能与git switch类似
git switch  #切换分支 该命令是 2.23 版本中新加入的!
git switch -c xxx   #(以当前分支为副本)创建并切换到分支上
git branch -a     #查看所有分支
git branch        #查看本地的分支情况
git branch --remote   #看远程仓库分支情况
git branch -d <branch-name>  #删除本地分支
git branch -m xxx  #更改当前分支名
git push -d origin <branch-name>  #删除远程分支
git status  #查看当前工作区状态
git add .   #提交到暂存区：包括新建/更改/删除
git commit -m "update"
git commit -am   #相当于 git add . & git commit -m
git push origin xxx   #推送至远端分支
git reset --hard HEAD^   #回退至上一个版本
git reset --hard 1094a   #回到某个特定版本
git merge xxx   #将xxx分支合并到当前分支
git remote -v   #查看远程库信息
git remote remove xxx  #删除远程库信息
git pull   #从远程库同步最新代码，相当于git fetch & git merge
git log --pretty=oneline
```

## 创建仓库并更新至远端
1. 登录github新建一个仓库，不要选择建立README.md
2. 本机git命令行操作
```
git init
git add .
git commit -m "commit1"
git branch -M main
git remote add github https://github.com/dumasee/deploy.git
git push -u origin main
```

## 从远程库拉取项目
```
git clone https://github.com/dumasee/deploy.git
git clone https://gitee.com/phoebus999/deploy.git
```

## 从远端库更新到本地
```
git pull origin xxx
```

## 配置git
- 添加代理
```
git config --global http.proxy 'socks5://127.0.0.1:10808'
git config --global https.proxy 'socks5://127.0.0.1:10808'
```

- 取消代理
```
git config --global --unset http.proxy
git config --global --unset https.proxy
```

- 配置默认参数
```
git config --global init.defaultbranch main
git config --global user.name "dumasee"
git config --global user.email "phoebus999@126.com"
```


## 报错处理
- refusing to merge unrelated histories
```
问题:
执行 git pull origin main 时报错  
fatal: refusing to merge unrelated histories
处理:
git merge main --allow-unrelated-histories
```

- failed to push some refs to ''
``` 
问题:
执行 git push origin main 时报错  
error: failed to push some refs to 'github.com:dumasee/tech_doc.git'  
处理：
git pull --rebase origin main
```

- git pull时报错，提示远程分支不存在
日志：
```
Your configuration specifies to merge with the ref 'refs/heads/redesign'
from the remote, but no such ref was fetched.
```
处理：  
使用命令行拉取新分支代码前使用：git fetch -p 获取最新分支 然后获取远程分支代码


## svn迁移到git
1. 安装
```
apt-get install git-svn
```
2. 操作
```
git svn clone svn://47.93.220.40:9999/项目列表/羿家人 --username=yank --no-metadata
cd 羿家人
git branch -M main
git remote add giteb http://192.168.11.6:3000/project/yijiaren.git
git push giteb main
```

## github
- 单仓库容量：1G
- 单个文件大小：100M
- 用户总仓库容量上限：无
- 私有库现在可免费使用，数量无限制，每个私有库最多可以有3人协作。

## gitee
企业版和社区版服务对比：https://gitee.com/help/articles/4167
企业版社区版功能对比：https://gitee.com/help/articles/4166
- 仓库数量上限：1000个，不限制公私有。
- 单仓库大小上限：500M
- 单文件大小上限：50M
- 用户总仓库容量上限：5G
- 公有仓库成员数量不限
- 个人帐号下所有私有库总的协作人数为5人
