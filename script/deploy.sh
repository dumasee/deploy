#!/bin/bash
#
#     Linux Deploy Tools
#     deploy.sh @ Version 0.39.27
#     date: 2022.04.20

#fonts color
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

readonly myHttpServer=192.168.22.9:3080

#check os
function pre_check(){
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    else
        red "NONE os version detected." && exit 1
    fi
    Codename=$(lsb_release -c --short)
    DEB_SRC="/etc/apt/sources.list"
}

#set pkg source
function config_src(){
    pre_check
    grep "^deb http://mirrors.cloud.aliyuncs.com" $DEB_SRC && return 0
    grep "gce.archive" $DEB_SRC && return 0
    time=$(date "+%Y%m%d%H%M")
    if [ "$release" == "ubuntu" ]; then
        mv $DEB_SRC ${DEB_SRC}_$time
        echo deb http://mirrors.aliyun.com/ubuntu/ ${Codename} main restricted universe multiverse >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/ubuntu/ ${Codename}-updates main restricted universe multiverse >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/ubuntu/ ${Codename}-security main restricted universe multiverse >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/ubuntu/ ${Codename}-backports main restricted universe multiverse >> $DEB_SRC
    elif [ "$release" == "debian" ]; then
        mv $DEB_SRC ${DEB_SRC}_$time
        echo deb http://mirrors.aliyun.com/debian ${Codename} main contrib non-free >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/debian ${Codename}-updates main contrib non-free >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/debian-security ${Codename}/updates main contrib non-free  >> $DEB_SRC
        echo deb http://mirrors.aliyun.com/debian/ ${Codename}-backports main contrib non-free  >> $DEB_SRC
    fi
    green "finished: config src." && return 0
}

function config_sshd(){
    local cfg=/etc/ssh/sshd_config
    sed -i '/^PermitRootLogin/c\PermitRootLogin yes' $cfg
    grep -q ^PermitRootLogin $cfg || sed -i '/^#PermitRootLogin/c\PermitRootLogin yes' $cfg
    sed -i '/^PasswordAuthentication/c\PasswordAuthentication yes' $cfg
    service ssh restart && green "finished: settings for sshd." && return 0
}

function config_vnstat(){
    local cfg=/etc/vnstat.conf
    iface=$(ip add|grep state|egrep -v "lo|docker" |awk '{print $2}' | sed 's/://g')
	iface_up=$(ip add|grep "state UP"|egrep -v "lo|docker" |awk '{print $2}' | sed 's/://g')
    iface_up_choose=$(echo ${iface_up}|awk '{print $1}')

    echo $iface |grep -q bond0
    if [ $? -eq 0 ]; then
        sed -i '/^Interface /c\Interface "bond0"' $cfg
        vnstat --add -i bond0  #for ubuntu20.04
        /etc/init.d/vnstat restart
        green "config vnstat -> default interface: bond0" 
        return 0
    fi

    if [ -n $iface_up_choose ]; then
        sed -i "/^Interface /c\Interface \"$iface_up\"" $cfg
        /etc/init.d/vnstat restart 
        green "config vnstat -> default interface: $iface_up_choose"
        return 0
    fi

    echo "vnstat not configured." && return 1
}

function config_os(){
    config_sshd
    config_vnstat
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && green "finished: config for timezone."
    [ -f /usr/bin/python ] || ln -s /usr/bin/python3 /usr/bin/python  #for ansible agent
    sed -i '/^HISTFILESIZE=/c\HISTFILESIZE=20000' /root/.bashrc
    [ -f /home/eb/.bashrc ] && sed -i '/^HISTFILESIZE=/c\HISTFILESIZE=20000' /home/eb/.bashrc
    [ -f /home/eb/.bashrc ] && sed -i '/^HISTSIZE=/c\HISTSIZE=10000' /home/eb/.bashrc
    
    #for CentOS
    if [ "$release" == "centos" ]; then
        sed -i '/^keepcache=/c\keepcache=1' /etc/yum.conf
        systemctl restart vnstat.service
    fi
    
    return 0
}


#install base sw
function install_base(){
    pre_check
    crontab -l|grep -Eqi ntpdate || (crontab -l | (cat;echo "9 */8 * * * /usr/sbin/ntpdate ntp3.aliyun.com") | crontab -)
    crontab -l|grep -Eqi vnstat || (crontab -l | (cat;echo "*/1 * * * * vnstat -u") | crontab -)
    if [ "$release" == "ubuntu" -o "$release" == "debian" ]; then
        apt-get -y update
        apt-get -y install bash-completion ntpdate iproute2 vnstat tmux zip wget curl vim sshpass
        apt-get -y install netcat dnsutils xz-utils iftop lrzsz sysstat moreutils jq htop
        service cron restart
        config_vnstat
        /etc/init.d/vnstat restart
    elif [ "$release" == "centos" ]; then
        yum makecache fast
        yum -y install epel-release bash-completion ntpdate vnstat tmux zip unzip wget curl
        yum -y install nc iftop lrzsz
        systemctl restart vnstat.service
        systemctl restart crond.service
    fi
    vnstat -u
    green "finished: install base." && return 0
}


function config_ansible(){
    local cfg=/etc/ansible/ansible.cfg
    sed -i '/^#forks /c\forks          = 100' $cfg
    sed -i '/^#poll_interval /c\poll_interval  = 15' $cfg
    sed -i '/^host_key_checking /c\host_key_checking = False' $cfg
    sed -i '/^#host_key_checking /c\host_key_checking = False' $cfg
    sed -i '/^#pipelining = False/c\pipelining = True' $cfg
    sed -i '/^#deprecation_warnings /c\deprecation_warnings = False' $cfg
    green "finished: config ansible" && return 0
}


function uninstall_yundun(){
    ps aux|grep -i AliYunDun|grep -vq grep || { echo "系统未启用YunDun" && return 1;}
    wget http://update.aegis.aliyun.com/download/uninstall.sh
    bash uninstall.sh
    wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh
    bash quartz_uninstall.sh
    
    #purge AliYunDun after uninstall
    pkill aliyun-service
    rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
    rm -rf /usr/local/aegis*
    green "finished: uninstall YunDun." && return 0
}


function config_mysql(){
    pre_check
    if [ "$release" == "ubuntu" -o "$release" == "debian" ]; then
    
        #for Debian8/Ubuntu14.04 mysql5.5
        local cfg_try=/etc/mysql/my.cnf
        grep bind-address $cfg_try && local cfg=$cfg_try && green "mysql config path：$cfg"
        
        #for Ubuntu16.04 mysql5.7
        local cfg_try=/etc/mysql/mysql.conf.d/mysqld.cnf
        grep bind-address $cfg_try && local cfg=$cfg_try && green "mysql config path：$cfg"

        #for Debian9/Debian10  default is Mariadb
        local cfg_try=/etc/mysql/mariadb.conf.d/50-server.cnf
        grep bind-address $cfg_try && local cfg=$cfg_try && green "mysql config path：$cfg"

        sed -i '/^bind-address/c\#bind-address = 127.0.0.1' $cfg

        #不区分大小写
        grep lower_case_table_names $cfg || sed -i '/^\[mysqld\]/a\lower_case_table_names = 1' $cfg

        #默认字符集
        grep character-set-server $cfg || sed -i '/^\[mysqld\]/a\character-set-server=utf8' $cfg
        grep "^\[client\]" $cfg || echo "[client]" >> $cfg
        grep "default-character-set" $cfg || sed -i '/^\[client\]/a\default-character-set=utf8' $cfg
        
        /etc/init.d/mysql restart
        
    elif [ "$release" == "centos" ]; then
        systemctl restart mariadb
        systemctl enable mariadb
    fi
    
    read -p "Do you want to start mysql_secure_installation? [y/n]: " -e -i y OPTION
    if [[ $OPTION = 'y' ]]; then
        mysql_secure_installation
    fi     
    
    
    [[ $? == 0 ]] && green "finished: config mysql."
    [[ $? == 0 ]] && green "为了给远程电脑登录数据库，你需要在mysql环境下执行授权命令："
    [[ $? == 0 ]] && red "mysql> grant all privileges on *.* to root@'%' identified by 'PASSWORD';"
    [[ $? == 0 ]] && red "mysql> flush privileges;" && return 0
}



function deploy_bak_mysql(){
    local url="http://$myHttpServer/bak_mysql.sh"   #download path for bakcup script.
    local f=$(basename $url)
    local d=$(cd;pwd)
    [ -f $f ] || wget $url
    chmod +x $f
    crontab -l|grep -Eqi bak_mysql || (crontab -l | (cat;echo "0 1 * * * $d/$f") | crontab -)
    green "finished: deploy bakmysql."
    red "edit $HOME/$f and change to your own db PASSWORD." && return 0
}

function install_redis() {
    dpkg -l|grep redis-server && echo "Nothing done, redis-server already installed." && return 1
    pre_check
    if [ "$release" == "ubuntu" -o "$release" == "debian" ]; then
        local CFG=/etc/redis/redis.conf
        apt-get -y update
        apt-get -y install redis-server
        rm -rf /var/cache/apt/archives/*.deb
        sed -i '/^bind 127.0.0.1/c\#bind 127.0.0.1 ::1' $CFG
        /etc/init.d/redis-server restart
        echo
        cat $CFG |grep "requirepass " && echo "如果需要启用密码连接，请编辑该行内容！" && echo "配置文件路径: $CFG"
    elif [ "$release" == "centos" ]; then
        local CFG=/etc/redis.conf
        yum -y install redis
        sed -i '/^bind 127.0.0.1/c\#bind 127.0.0.1 ::1' $CFG
    fi
    green "finished: install redis." && return 0
}


function clear_history(){
    local f=clear.sh
    touch $f
    echo "set -o history" >> $f
    echo "echo > /var/log/wtmp" >> $f
    echo "echo > /var/log/btmp" >> $f
    echo "echo > ~/.bash_history" >> $f
    echo "history -c" >> $f
    green "run the following:"
    red "source $f && rm -rf $f" && return 0
}

function deploy_extra_redis() {
    ps aux|grep redis |grep -vq grep || { echo "no redis installed." && return 1;}
    [ $(ps aux|grep redis|grep -v grep|wc -l) -gt 1 ] && echo "you have more than one redis process." && return 1
    #read -p "请输入需额外部署的redis进程数量:" number_of_redis
    local number_of_redis=3
    local count=0
    local p=6380
    while [ true ]
    do
        [ $count -eq $number_of_redis ] && \
            echo "slaveof 127.0.0.1 6380" >> /etc/redis/redis_6381.conf \
            && echo "finished: deploy extra " && exit 0
        local cfg_stand=/etc/redis/redis.conf
        local cfg=/etc/redis/redis_${p}.conf
        cp -rp $cfg_stand $cfg
        sed -i "/^pidfile/c\pidfile /var/run/redis/redis-server_${p}.pid" $cfg
        sed -i "/^port/c\port ${p}" $cfg
        sed -i "/^logfile/c\logfile /var/log/redis/redis-server_${p}.log" $cfg
        sed -i "/^dbfilename/c\dbfilename dump_${p}.rdb" $cfg
        sudo -u redis /usr/bin/redis-server  $cfg >/dev/null 2>&1 &   #RUN
        count=$(($count+1))
        p=$(($p+1))
    done
    return 0
}


function install_zookeeper(){
    java -version || { echo "zookeeper依赖JDK，install JDK first" && return 1;}
    #local url="https://archive.apache.org/dist/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz"
    local url="http://$myHttpServer/linux/zookeeper-3.4.5.tar.gz"
    local f=$(basename $url)
    local dir=$(basename $url .tar.gz)
    local log=installzookeeper.log
    [ -f $f ] || wget $url
    tar zxvf $f
    mv $dir /usr/local/
    cd /usr/local/$dir/conf/
    cp zoo_sample.cfg zoo.cfg
    sed -i '/^dataDir=/c\dataDir=/data1/zookeeper' zoo.cfg
    mkdir -p /data1/zookeeper

    local pf=/etc/profile
    echo "export ZOOKEEPER_HOME=/usr/local/$dir" >> $pf
    echo 'export PATH=${ZOOKEEPER_HOME}/bin:$PATH' >> $pf
    source $pf
    zkServer.sh start
    echo
    echo "config path：/usr/local/$dir/conf/zoo.cfg" | tee $log
    echo "start/stop/status：" | tee -a $log
    echo "zkServer.sh start" | tee -a $log
    echo "zkServer.sh stop" | tee -a $log
    echo "zkServer.sh status" | tee -a $log
    echo "zkCli.sh -server localhost:2181" | tee -a $log
    cat /usr/local/$dir/conf/zoo.cfg |grep clientPort && echo "zookeeper port should be permit in Firewall."
    green "finished: install zookeeper." && return 0
}

function install_kafka(){
    java -version || { echo "kafka依赖JDK，请先安装JDK" && return 1;}
    #ps aux|grep kafka |grep -vq grep && echo "Nothing done, kafka already installed." && return 2
    #local url=https://archive.apache.org/dist/kafka/0.11.0.3/kafka_2.11-0.11.0.3.tgz
    local url=http://$myHttpServer/linux/kafka_2.11-0.11.0.3.tgz
    local f=$(basename $url)
    local dir=$(basename $url .tgz)
    local log=/root/installkafka.log
    local cfg=/usr/local/$dir/config/server.properties
    [ -f $f ] || wget $url
    tar zxvf $f
    mv $dir/ /usr/local/
    cd /usr/local/$dir/config
    cp server.properties server.properties.bak
    sed -i '/^log.dirs=/c\log.dirs=/data1/kafka-logs' server.properties
    grep ^listeners=PLAINTEXT server.properties || sed -i '/^#listeners=PLAINTEXT/c\listeners=PLAINTEXT://127.0.0.1:9092' server.properties
    mkdir -p /data1/kafka-logs
    echo
    grep zookeeper.connect= server.properties && echo "需要更改为当前zookeeper的地址及端口号！"
    echo
    echo "start：" | tee $log
    echo "cd /usr/local/$dir/bin && ./kafka-server-start.sh ../config/server.properties 1>/dev/null 2>&1 &" | tee -a $log
    echo "bin path：/usr/local/$dir/bin" | tee -a $log
    echo "config path：/usr/local/$dir/config/server.properties" | tee -a $log
    green "finished: install kafka." && return 0
}


#JiaoYiSuo 行情服务 ubuntu18.04 prefered.
function deploy_quotes(){
    pre_check
    [[ "$release" == "ubuntu" ]] || { echo "Unsupported system." && return 1;}
    apt-get -y install build-essential libssl-dev libev-dev libjansson-dev libmpdec-dev libmysql++-dev libzookeeper-mt-dev zip librdkafka-dev && green "finished: install compied."
    
    local url=http://$myHttpServer/soft-eb/jys/match_quote.zip
    local f=$(basename $url)
    [ -f $f ] || { wget $url && green "已完成：$f下载。"; }
    [[ $? == 0 ]] && unzip $f && green "已完成：$f解压。"
    
    #编译安装hiredis
    [[ $? == 0 ]] && cd /root/match_quote/viabtc_exchange_server/depends/hiredis/ && make && make install && green "已完成：编译安装hiredis"
    
    #编译network & utils
    [[ $? == 0 ]] && cd /root/match_quote/quote/network && make && green "已完成：编译network"
    [[ $? == 0 ]] && cd /root/match_quote/quote/utils && make && green "已完成：编译utils"
    
    #编译quote
    [[ $? == 0 ]] && cd /root/match_quote/quote/dealserver && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/depthserver && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/hqserver_http && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/hqserver_ws && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/klineserver && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/marketprice && make
    [[ $? == 0 ]] && cd /root/match_quote/quote/stateserver && make
    
    mkdir -p /root/dealserver/
    mkdir -p /root/depthserver/
    mkdir -p /root/hqserver_http/
    mkdir -p /root/hqserver_ws/
    mkdir -p /root/klineserver/
    mkdir -p /root/marketprice/
    mkdir -p /root/stateserver/
    
    cp -rp /root/match_quote/quote/dealserver/dealserver /root/dealserver/
    cp -rp /root/match_quote/quote/depthserver/depthserver /root/depthserver/
    cp -rp /root/match_quote/quote/hqserver_http/hqserver_http /root/hqserver_http/
    cp -rp /root/match_quote/quote/hqserver_ws/hqserver_ws /root/hqserver_ws/
    cp -rp /root/match_quote/quote/klineserver/klineserver /root/klineserver/
    cp -rp /root/match_quote/quote/marketprice/marketprice /root/marketprice/
    cp -rp /root/match_quote/quote/stateserver/stateserver /root/stateserver/
    
    [[ $? == 0 ]] && green "行情服务编译完成。"
    [[ $? == 0 ]] && green '二进制文件依赖验证：cd dealserver/ && ldd dealserver' && return 0
}

#交易所 撮合服务 推荐ubuntu18.04
function deploy_match(){
    pre_check
    [[ "$release" == "ubuntu" ]] || { echo "Unsupported system." && return 1;}
    apt-get -y install build-essential libssl-dev libev-dev libjansson-dev libmpdec-dev libmysql++-dev libzookeeper-mt-dev && green "已完成：编译环境安装"
    [[ "$release" == "ubuntu" && ${Codename} == "bionic" ]] && apt-get -y install librdkafka-dev

    #ubuntu16.04
    if [[ "$release" == "ubuntu" && ${Codename} == "xenial" ]];then
        wget https://codeload.github.com/edenhill/librdkafka/zip/0.11.x -O librdkafka-0.11.x
        mv librdkafka-0.11.x librdkafka-0.11.x.zip
        unzip librdkafka-0.11.x.zip
        cd /root/librdkafka-0.11.x && ./configure && make && make install
    fi

    local url=http://$myHttpServer/soft-eb/jys/match_quote.zip
    local f=$(basename $url)
    [ -f $f ] || { wget $url && green "已完成：$f下载。"; }
    [[ $? == 0 ]] && unzip $f && green "已完成：$f解压。"

    #编译安装hiredis
    [[ $? == 0 ]] && cd /root/match_quote/viabtc_exchange_server/depends/hiredis/ && make && make install && green "已完成：编译安装hiredis"
    
    #编译network & utils
    [[ $? == 0 ]] && cd /root/match_quote/matchengine/src/network && make && green "已完成：编译network"
    [[ $? == 0 ]] && cd /root/match_quote/matchengine/src/utils && make && green "已完成：编译utils"
    
    #编译matchengine
    [[ $? == 0 ]] && cd /root/match_quote/matchengine/src/ && make && green "已完成：编译matchengine"
    
    #复制可执行文件
    [[ $? == 0 ]] && mkdir -p /root/matchengine/
    [[ $? == 0 ]] && cp -rp /root/match_quote/matchengine/src/matchengine /root/matchengine/
    [[ $? == 0 ]] && cp -rp /usr/local/lib/libhiredis.so.0.13  /usr/lib/x86_64-linux-gnu/     #ubuntu18.04
    return 0
}

function install_docker(){
    docker -v && echo "docker installed already." && return 1
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun && green "finished：install docker"
}

function deploy_docker_python(){
    pre_check && [[ ${Codename} != "bionic" ]] && echo "OS version NOT supported!"
    docker -v || { red "系统未安装docker." && install_docker; }
    
    #定制镜像
    cd /root/
    local url=http://$myHttpServer/soft-eb/jys/20200715/python.tar
    local f=$(basename $url)
    [ -f $f ] || { wget $url && green "已完成：$f下载。"; }
    [[ $? == 0 ]] && tar xvf $f && green "已完成：$f解压。"
    [[ $? == 0 ]] && docker build -t prod:python /root/python/  && green "已完成：镜像定制"    #这个过程比较耗时！
    
    apt-get -y install python3-pip
    pip3 install fire

    python3 /root/python/service.py start && return 0
}


#install GPU driver
function install_gpu(){
    nvidia-smi && echo "GPU already installed." && return 1
    #url=https://us.download.nvidia.com/XFree86/Linux-x86_64/460.67/NVIDIA-Linux-x86_64-460.67.run
    
    cd /opt
    url="http://$myHttpServer/linux/NVIDIA-Linux-x86_64-460.67.run"
    f=$(basename $url)
    [ -f $f ] || wget -c $url    
    
    blist=/etc/modprobe.d/blacklist.conf
    apt-get install -y gcc build-essential  #gpu need these pkgs.
    update-pciids
    bash $f --silent && update-initramfs -u
    grep nouveau $blist || echo blacklist nouveau >> $blist
    
    nvidia-smi -q|grep "Product Name"
    if [ $? -eq 0 ];then
        echo "驱动安装成功"
    else
        echo "驱动安装失败"
    fi
    return 0
}

function run_dcgm_exporter(){
    docker image ls|grep dcgm-exporter || return 1
    docker ps -a|grep dcgm-exporter || docker run -d --gpus all --rm -p 9400:9400 nvidia/dcgm-exporter:latest
}

#deploy gpu monitor
function deploy_dcgm_exporter(){
    install_docker
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
    apt-get -y update && apt-get -y install nvidia-docker2 && systemctl restart docker
    sleep 3s
    docker image ls|grep dcgm-exporter || docker pull nvidia/dcgm-exporter
    run_dcgm_exporter && green "finished: deploy dcgm exporter." && return 0
}

#超算&算力&miner
function deploy_worker(){
    install_base
    install_gpu
    deploy_dcgm_exporter
    apt-get -y install nfs-common
    apt install -y mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang
    apt install -y build-essential hwloc libhwloc-dev htop vim dstat net-tools glances make
    return 0
}

#megacli take too much time to install online.Suggest install it offline.
function install_megacli(){
    cd /opt
    url="http://$myHttpServer/linux/megacli/megacli_8.07.14-1_amd64.deb"
    f=$(basename $url)
    [ -f $f ] || wget -c $url
	dpkg -i $f    
    
    cd /opt
    url="http://$myHttpServer/linux/storcli_007.1613.0000.0000_all.deb"
    f=$(basename $url)
    [ -f $f ] || wget -c $url
	dpkg -i $f && ln -s /opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli
	apt-get -y --fix-broken install
    
    
    mkdir /opt/deploy
    cd /opt/deploy
    url="http://$myHttpServer/linux/megacli/lsi.sh"
    f=$(basename $url)
    [ -f $f ] || wget -c $url
    
    return 0
}

function install_nfs_server(){
    apt-get -y install nfs-kernel-server
    grep /mnt/data /etc/exports || echo "/mnt/data1/ *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
	/etc/init.d/nfs-kernel-server restart
    green "nfs server installed." && return 0
}

#存储
function deploy_storage(){
    config_os
    install_base && install_nfs_server && install_megacli
    return 0
}


function deploy_node_exporter(){
    cd /opt/
    url="http://$myHttpServer/linux/prometheus/node_exporter-1.1.1.linux-amd64.tar.gz"
    f=$(basename $url)
    [ -f $f ] || wget -c $url
    tar zxvf $f
    
    mkdir /opt/deploy
    cd /opt/deploy
    url="http://$myHttpServer/linux/prometheus/exporter_start.sh"
    f=$(basename $url)
    [ -f $f ] || wget -c $url    

    mkdir -p /tmp/textcollector
    cd /opt/node_exporter*/ && nohup ./node_exporter --collector.textfile.directory="/tmp/textcollector" > /dev/null 2>&1 &
}

function restart_node_exporter(){
    killall node_exporter
    sleep 3s
    mkdir -p /tmp/textcollector
    cd /opt/node_exporter*/ && nohup ./node_exporter --collector.textfile.directory="/tmp/textcollector" > /dev/null 2>&1 &
}


function hwinfo(){
    model=$(cat /proc/cpuinfo |grep "model name"|head -1|awk -F: '{print $2}')
    cpus=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
    cores=$(grep 'core id' /proc/cpuinfo | sort -u | wc -l)
    threads=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
    echo
    echo 'CPU类型:' $model 
    echo 'cpu数量/每cpu核心数/总线程数: '$cpus'/'$cores'/'$threads
    #mem=$(dmidecode |grep -A16 "Memory Device"|grep -i size)
    mem=$(free -h|grep Mem|awk '{print $2}')
    echo 'Mem: ' $mem
    echo && echo 'Disk:' && fdisk -l|grep Disk|grep dev|grep -v loop
    echo && echo "Ethernet:" && lspci|grep -i net
    echo && echo 'VGA:' && lspci |grep -i vga
    echo && echo 'Raid:' && lspci |grep -i raid
    
    return 0
}

function gen_fstab(){
    local n=$(lsblk -f|head -1|wc|awk '{print $2}')   #lsblk -f输出包含几列，分两种情况分别处理：
    if [ $n -eq 5 ]; then
        lsblk -f|grep /|grep - |awk '{print "UUID="$3,$4,$2,"defaults","0 0"}'
        return 0
    elif [ $n -eq 7 ]; then
        lsblk -f|grep /|grep - |awk '{print "UUID="$3,$6,$2,"defaults","0 0"}'
        return 0
    fi
    return 1
}

function gen_fstab_nfs(){
    df -hT|egrep 'nfs' |awk '{print $1,$7,"nfs","defaults,_netdev","0 0"}'
}

function showssd(){
    echo
    intelmas show -intelssd|grep -B3 Index
    echo
}

function upgradessd(){
    echo
    intelmas show -intelssd|grep -B3 Index 
    echo
    echo "Now Please wait the upgrade process...."
    sleep 3s
    INDEX=$(intelmas show -intelssd|grep Index |awk '{print $3}')
    for i in $INDEX
    do
      intelmas load -intelssd $i  
      sleep 3s
    done
}

function deploy_chia(){
    config_os
    install_base
    apt-get -y install nfs-common
    return 0
}


if [ $# -eq 0 ]
   then
    echo
    echo "Usage"
    echo "-----------------------------------------------------"
    echo "COMMANDS:"
    echo "configsrc             config for /etc/apt/sources.list"
    echo "configsshd            config for /etc/ssh/sshd_config"
    echo "configvnstat          config for /etc/vnstat.conf"
    echo "configos              config for src & sshd & vnstat"
    echo "configansible         config for /etc/ansible/ansible.cfg"
    echo "base                  Deploy Base software and package"
    echo "uninstallyundun       uninstall AliYunDun"
    echo "configmysql           config MySQL"
    echo "bakmysql              deploy to bakup mysql"
    echo "redis                 install Redis"
    echo "docker                install Docker"
    echo "clearhistory          clear history"
    echo "zookeeper             install zookeeper"
    echo "kafka                 install kafka"
    echo "extraredis            deploy extra Redis for JYS"
    echo "jysquotes             deploy JYS quotes"
    echo "jysmatch              deploy JYS match"
    echo "jysdockerpython       deploy JYS docker python"
    echo "hwinfo                display hardware info"
    echo "gpu                   install GPU driver"
    echo "dcgmexporter          deploy dcgm exporter"
    echo "rungpudocker          run dcgm exporter"
    echo "ipfsworker            deploy IPFS worker"
    echo "nfsserver             install NFS server"
    echo "genfstab              generate for fstab"
    echo "genfstab4nfs          generate for fstab of nfs"
    echo "showssd               show intelssd firmware info"
    echo "upgradessd            show intelssd firmware info & upgrade"
    echo "node_exporter         deploy_node_exporter"
    echo "restart_node_exporter restart_node_exporter"
	echo "megacli               install meagcli/storcli"
    echo "chia                  deploy chia plot server"
    echo "storage               deploy chia/ipfs storage"
    echo
   exit
 fi

if [ $1 = "configsrc" ];then
    config_src
fi

if [ $1 = "configsshd" ];then
    config_sshd
fi

if [ $1 = "configvnstat" ];then
    config_vnstat
fi

if [ $1 = "configos" ];then
    config_os
fi

if [ $1 = "base" ];then
    install_base
fi

if [ $1 = "configansible" ];then
    config_ansible
fi

if [ $1 = "uninstallyundun" ];then
    uninstall_yundun
fi

if [ $1 = "bakmysql" ];then
    deploy_bak_mysql
fi

if [ $1 = "configmysql" ];then
    config_mysql
fi

if [ $1 = "redis" ];then
    install_redis
fi


if [ $1 = "clearhistory" ];then
    clear_history
fi

if [ $1 = "extraredis" ];then
    deploy_extra_redis
fi

if [ $1 = "zookeeper" ];then
    install_zookeeper
fi

if [ $1 = "kafka" ];then
    install_kafka
fi

if [ $1 = "docker" ];then
    install_docker
fi

if [ $1 = "jysquotes" ];then
    deploy_quotes
fi

if [ $1 = "jysmatch" ];then
    deploy_match
fi

if [ $1 = "jysdockerpython" ];then
    deploy_docker_python
fi

if [ $1 = "gpu" ];then
    install_gpu
fi

if [ $1 = "dcgmexporter" ];then
    deploy_dcgm_exporter
fi

if [ $1 = "rungpudocker" ];then
    run_dcgm_exporter
fi

if [ $1 = "meagcli" ];then
    install_meagcli
fi

if [ $1 = "nfsserver" ];then
    install_nfs_server
fi

if [ $1 = "ipfsworker" ];then
    deploy_worker
fi


if [ $1 = "hwinfo" ];then
    hwinfo
fi

if [ $1 = "genfstab" ];then
    gen_fstab
fi

if [ $1 = "genfstab4nfs" ];then
    gen_fstab_nfs
fi

if [ $1 = "showssd" ];then
    showssd
fi

if [ $1 = "upgradessd" ];then
    upgradessd
fi

if [ $1 = "node_exporter" ];then
    deploy_node_exporter
fi

if [ $1 = "restart_node_exporter" ];then
    restart_node_exporter
fi


if [ $1 = "megacli" ];then
    install_megacli
fi

if [ $1 = "chia" ];then
    deploy_chia
fi

if [ $1 = "storage" ];then
    deploy_storage
fi
