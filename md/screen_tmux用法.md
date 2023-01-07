##  screen
```
screen -S Name   启动一个screen会话
screen -ls  显示screen会话
screen -r <name>|<id>  切回screen会话
screen -r -x  多人共享切回一个screen会话
screen -d  退出screen会话


Ctrl+a,Ctrl+a 切换不同窗口
Ctrl+a,w 显示会话所有窗口
Ctrl+a,c 新建一个窗口
Ctrl+a,d 切出会话
```

##  tmux
```
tmux   新建并进入会话
tmux ls  显示会话列表
tmux a 返回至最近的会话
tmux rename -t 0  xxx  重命名会话
tmux attach-session -t xxx 返回到指定会话
tmux attach-session 返回到上一个会话
Ctrl+b，s  选择切换不同的会话
Ctrl+b，d  切出会话
Ctrl+b，[  copy模式，可以滚屏
Ctrl+b, " 水平分割当前单个窗格
Ctrl+b, % 垂直分割当前单个窗格
Ctrl+b，然后点箭头键 浏览其它窗格
```

## 编译安装tmux  
centos6安装tmux
1. 安装libevent
```
tar zxvf libevent-1.4.14b-stable.tar.gz  #版本2.x会编译报错
./configure && make && make install
```

2. 安装tmux
```
tar zxvf tmux-2.9.tar.gz  #tmux可以是最新版
./configure && make && make install
```