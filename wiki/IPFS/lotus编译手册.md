 XWiki - 设计文档.IPFS.lotus编译手册 - lotus编译手册              

* * *

 安装依赖

1、\[安装 go\]([https://blog.csdn.net/weixin\_43932656/article/details/106528932)](https://blog.csdn.net/weixin_43932656/article/details/106528932))  
wget -c [https://golang.org/dl/go1.15.5.linux-amd64.tar.gz](https://golang.org/dl/go1.15.5.linux-amd64.tar.gz) -O - | sudo tar -xz -C /usr/local  
tar -zxvf go1.15.5.linux-amd64.tar.gz -C /usr/local

export GOROOT="/usr/local/go"  
export GOPATH="/usr/local/gopath"  
export PATH=$PATH:/root/.cargo/bin:$GOROOT/bin

2、安装其它依赖  
sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev -y && sudo apt upgrade -y

3、\[安装 rustup\]([https://skyao.io/learning-rust/installation/linux.html)](https://skyao.io/learning-rust/installation/linux.html))  
curl proto '=https' tlsv1.2 -sSf [https://sh.rustup.rs](https://sh.rustup.rs) | sh

安装完，想在终端立即生效：  
source $HOME/.cargo/env

4\. 下载 Lotus  
svn co [svn://47.93.220.40:9999/](svn://47.93.220.40:9999/)项目列表/IPFS分布式存储项目/开发管理/filecoin-project

5\. 编译  
cd lotus\_1.5.0/

6\. 修改文件权限(因为需要涉及到几个文件的可执行权限，extern/filecoin-ffi/rust/scripts/build-release.sh，extern/filecoin-ffi/install-filcrypto)  
chmod 775 -R ./\*

#使用intel CPU  
FFI\_BUILD\_FROM\_SOURCE=1 CGO\_CFLAGS="-O -DBLST\_PORTABLE" make clean all

#使用amd cpu  
RUSTFLAGS="-C target-cpu=native -g" FFI\_BUILD\_FROM\_SOURCE=1 make clean all

**注意：  
沈阳太原可以miner和worker都是3090的显卡，所有用我们filecoin\_project的版本没有问题，但是他们的超算是intel的CPU。所以需要放到intel的cpu机上编译。  
郑州的客户由于miner是2080TI的显卡，worker是3090的显卡，所以需要注意miner编译的时候用2080Ti的bellperson的文件，算力机和超算他们都是用的amd的cpu和3090的显卡，所以只要编译一边好了。**

