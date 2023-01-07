#!/bin/bash
#
#     jdk_install.sh @ Version 0.5
#     date: 2022.03.10


#readonly myHttpServer=192.168.11.6:3080
readonly myHttpServer=111.0.121.226:13080

java -version && echo "JDK already installed." && return 0
url="http://$myHttpServer/linux/jdk-8u261-linux-x64.tar.gz"
wget -c $url
f=$(basename $url)
mkdir -p /usr/lib/jvm
cp -rp $f /usr/lib/jvm
cd /usr/lib/jvm && tar zxvf $f && rm -rf $f
cd jdk*_*
dir_jdk=$(pwd)
pf=/etc/profile
grep JAVA_HOME= $pf && echo "$pf：环境变量已存在!" && exit 0
grep JRE_HOME= $pf && echo "$pf：环境变量已存在!" && exit 0
grep CLASSPATH= $pf && echo "$pf：环境变量已存在!" && exit 0
echo "export JAVA_HOME=${dir_jdk}" >> $pf
echo 'export JRE_HOME=${JAVA_HOME}/jre' >> $pf
echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >> $pf
echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $pf
echo "已完成：JDK安装。"
echo "logout and relogin or exec the following to activate the envirement."
echo "source $pf"
