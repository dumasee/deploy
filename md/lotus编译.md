## 链接
https://github.com/filecoin-project/lotus

## 环境
```
22.23  ubuntu18.04  1.18.0编译成功!
22.22  ubuntu20.04  编译成功!
22.24  ubuntu20.04  已升级 1.16.0
21.122 ubuntu22.04  该系统版本下没编译过。
```

说明：ubuntu18.04下面编译生成的二进制程序，可以在20.04版本下运行。  


## 步骤
1. 安装依赖
```
apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev wget
apt upgrade -y
```

2. 安装go
```
wget -c https://go.dev/dl/go1.18.7.linux-amd64.tar.gz
tar zxvf go1.18.7.linux-amd64.tar.gz
mv go /usr/local/

echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile && source /etc/profile
```

3. 编译lotus
```
git clone https://github.com/filecoin-project/lotus.git
cd lotus/
git checkout v1.18.1

make clean all    #编译
make install     #安装
```

## 问题
1.17 官方编译版本无法使用
```
root@worker2722:~# lotus -v
lotus: error while loading shared libraries: libhwloc.so.15: cannot open shared object file: No such file or directory
root@worker2722:~# 
```
