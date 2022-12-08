#!/bin/bash

#     
#     runjar.sh @ Version 0.13
#     date: 2022.12.08


APP_NAME=yb-digital-1.0.0.jar
APP_PORTS="8091 8092"


is_exist(){
  local port=$1
  local pid=`ps -ef|grep $APP_NAME | grep java | grep $port | grep -v grep|awk '{print $2}'`
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
    return 1
  else
    return 0
  fi
}

start1(){
  local port=$1
  is_exist $port
  if [ $? -eq "0" ];then
    echo already running: $port
  else
    mv $port.log "$port.log.`date +'%F-%T'`"
    nohup java -jar -Dspring.profiles.active=prod $APP_NAME --spring.profiles.active=prod --server.port=$port 2>&1 >> $port.log &
    echo started: $port
  fi
}
 

stop1(){
  local port=$1
  local pid=$(ps -ef|grep $APP_NAME | grep java | grep $port | grep -v grep|awk '{print $2}')
  is_exist $port
  if [ $? -eq "0" ];then
    kill -9 $pid && echo stoped: $port
  else
    echo not running: $port
  fi
}
 
#启动方法
start(){
  for i in $APP_PORTS
  do
    start1 $i
  done
  return 0
}
 
#停止方法
stop(){
  for i in $APP_PORTS
  do
    stop1 $i
  done
  return 0
}
 

if [ $# -eq 0 ];then
    echo "Usage: sh 执行脚本.sh [start|stop]"
    exit
fi

if [ $1 = "start" ];then
    start
fi

if [ $1 = "stop" ];then
    stop
fi
