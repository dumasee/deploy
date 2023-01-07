

## 查找目录下文件
```
find /windows/work -maxdepth 5 -name "debug*rad*" 
find /windows -name "*xfs*"
find /windows -iname "*xfs*"   #大小写不敏感
find /home  -type f -size +500M   #根据大小查找文件
```
## 查找并删除文件
```
rm -rf $(find /home  -type f -size +400M)
```

## 删除当前目录及子目录下10天前的文件
```
find . -ctime 10 -name \*.rrd -type f -exec rm -f '{}' \;
```

