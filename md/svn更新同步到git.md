## 步骤
1. svn更新到本地
```
cd /opt/repos/svn/四海一家
svn update
```

2. git拉取最新版本
```
cd /opt/repos/git/QingDouMateDigitalCollection
git branch
git pull
```

3. 将svn更改的文件更新至git
```
cd /opt/repos
find ./ -name DigitalCollectionServiceImpl.java |xargs ls -lht

cp ./svn/四海一家/开发管理/后端开发/sihaiyijia/yb-service/yb-portal/src/main/java/com/yb/portal/digital/service/impl/DigitalCollectionServiceImpl.java ./git/QingDouMateDigitalCollection/sihaiyijia/yb-service/yb-portal/src/main/java/com/yb/portal/digital/service/impl/DigitalCollectionServiceImpl.java
```
4. git推送到远程库
```
cd /opt/repos/git/QingDouMateDigitalCollection
git add .
git commit -m modify_DigitalCollectionServiceImpl.java
git push origin dev-1.0
```