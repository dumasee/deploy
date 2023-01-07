##  tar命令 
```
#打包目录并压缩，保留目录结构
tar -zcvf File.tar.gz /AA/BB/dir/

#打包目录并压缩，不保留目录结构
cd /AA/BB && tar -zcvf File.tar.gz dir/
或者：
tar -zcvf File.tar.gz -C /AA/BB/ dir/    #-C表示change到此目录

#追加文件，只能是tar文件，不能压缩
tar -rvf FileName.tar.gz file2.txt

#解压
tar -zxvf FileName.tar.gz

#指定解压目录
tar zxvf FileName.tar.gz -C /

#查看文件
tar -tvf svn6666.tar.gz

#解压zip文件
unzip xx.zip -d dir/

#解压xz文件
xz -d test.tar.xz
```

##  实例  
打包目录下文件 ，当目录为绝对路径时则生成的tar文件带目录结构
```
tar cvf svn6666.tar /mnt/svn/project/conf/
tar cvf svn9999.tar /usr/local/svn/svnrepos/authz /usr/local/svn/svnrepos/passwd
```
