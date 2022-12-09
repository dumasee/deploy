#!/bin/bash

#     
#     jarun.sh @ Version 0.31
#     date: 2022.12.08


readonly APP_NAME=test-digital-1.0.0.jar
readonly APP_PORTS="8091 8092 "   #多个端口以空格隔开
readonly MODE=prod    # dev/test/prod


is_exist(){
  local jarname=$1
  local port=$2
  local pid=`ps -ef|grep $jarname | grep java | grep $port | grep -v grep|awk '{print $2}'`
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
    return 1
  else
    return 0
  fi
}


start_jar(){
  local jarname=$1
  local port=$2
  is_exist $jarname $port
  if [ $? -eq "0" ];then
    echo $jarname $port  [already running]
  else
    mv $port.log "$port.log.`date +'%F-%T'`"
    nohup java -jar -Dspring.profiles.active=$MODE $jarname --spring.profiles.active=$MODE --server.port=$port > $port.log 2>&1 &
    echo $jarname $port  [started.]
  fi
}
 

stop_jar(){
  local jarname=$1
  local port=$2
  local pid=$(ps -ef|grep $jarname | grep java | grep $port | grep -v grep|awk '{print $2}')
  is_exist $jarname $port
  if [ $? -eq "0" ];then
    kill -9 $pid && echo $jarname $port  [stoped.]
  else
    echo $jarname $port  [not running]
  fi
}

status_jar(){
  local jarname=$1
  local port=$2
  is_exist $jarname $port
  if [ $? -eq "0" ];then
    echo $jarname $port  [running]
  else
    echo $jarname $port  [down]
  fi
}
 
#启动方法
start(){
  for i in $APP_PORTS
  do
    start_jar $APP_NAME $i
  done
  return 0
}
 
#停止方法
stop(){
  for i in $APP_PORTS
  do
    stop_jar $APP_NAME $i
  done
  return 0
}

#状态
status(){
  for i in $APP_PORTS
  do
    status_jar $APP_NAME $i
  done
  return 0
}

usage(){
  echo Usage:
  echo "$0 <start|stop|status>"
  return 0
}
 

if [ $# -eq 0 ];then
    usage
    exit 0
fi

if [ $1 = "start" ];then
    start
    exit 0
fi

if [ $1 = "stop" ];then
    stop
    exit 0
fi

if [ $1 = "status" ];then
    status
    exit 0
fi