## 安装及初始化
python -m pip install --upgrade pip
pip install oss2 pandas zmail xlrd


##  Python版http服务器 
python3 -m http.server 8000    #简易http server
python -m SimpleHTTPServer 8000   #python2.x



## 安装第三方库推荐使用pip（需要管理员权限）
pip:包和依赖关系管理工具
```
pip install xxx   #安装模块
pip install -U xxx   #更新模块
pip list  #列出已安装的模块
apt-get install python3-pip  #安装pip3
python  -m pip install --upgrade pip  #升级pip
```


## 使用setup.py离线安装模块
```
pip3 install --upgrade setuptools
python3 setup.py install
```

## 安装依赖
```
sudo pip3 install -r requirements.txt
```

## 某些不能pip安装的，下载.whl直接安装
```
https://www.lfd.uci.edu/~gohlke/pythonlibs/
安装方法：pip install xxx.whl
```

## 更改pip/pip3镜像源
```
mkdir ~/.pip
vim ~/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
```

