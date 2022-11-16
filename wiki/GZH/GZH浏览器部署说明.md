 XWiki - 设计文档.GZH.GZH浏览器部署说明 - GZH浏览器部署说明          
* * *

1.  安装nvm(node版本管理器)  
    $:curl -o- [https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh) | bash  
    如果不成功则可能是dns有问题  
    注：（shell连接）安装完成后需要重新登录终端使环境变量生效  
    然后 source /.bashrc  
    $:nvm i v6  
    $:nvm use v6  
    更多安装说明请参考 [https://github.com/creationix/nvm](https://github.com/creationix/nvm)

2\. 安装mongo数据库相关  
安装步骤请参考官方文档 [https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)  
安装完成启动：`sudo service mongod start`
```
echo "mongodb-org hold" | sudo dpkg set-selections  
echo "mongodb-org-server hold" | sudo dpkg set-selections  
echo "mongodb-org-shell hold" | sudo dpkg set-selections  
echo "mongodb-org-mongos hold" | sudo dpkg set-selections  
echo "mongodb-org-tools hold" | sudo dpkg set-selections
```
3\. 其他所需支持  
安装zmq支持  
```
sudo apt-get install libzmq3-dev  
```
4\. 部署服务节点  
 下载所需节点的bitcore版本  
 修改链参数并编译生成节点主程序（编译gzh-bitcore），

1.  进入gzh-bitcore目录,  
     2. 执行`./autogen.sh`
     3. 执行`./configure`
     4. 执行make  
      (如果./autogen.sh和./configure执行不通，则需要将autogen.sh,configure,genbuild.sh这三个文件变为可执行文件）  
      chmod +x autogen.sh  
      chmod +x configure  
      cd share/ && chmod +x genbuild.sh && cd ..  
      )

 5. 部署node

1.  在/目录下安装node以及所有依赖组件  
      npm i [https://github.com/qtumproject/qtumcore-node.git#master](https://github.com/qtumproject/qtumcore-node.git#master)  
      2. 创建节点  
      #（npm bin为qtumcore-node实际安装目录，例如/root/node\_modules/qtumcore-node/bin）  
      $(npm bin)/root/node\_modules/qtumcore-node/bin/qtumcore-node create mynode  
      3.安装服务api和浏览器依赖组件  
      cd mynode  
      $(npm bin) /root/node\_modules/qtumcore-node/bin/qtumcore-node install [https://github.com/qtumproject/insight-api.git#master](https://github.com/qtumproject/insight-api.git#master)  
      $(npm bin) /root/node\_modules/qtumcore-node/bin/qtumcore-node install [https://github.com/qtumproject/qtum-explorer.git#master](https://github.com/qtumproject/qtum-explorer.git#master)  
      4. 替换node,api,explorer相关代码  
      将/mynode/node\_modules/下的qtum-explorer,qtum-insight-api,qtumcore-node替换成相应的代码，如果有对应代码，则跳过第二个步骤，如果没有，则执行第二个步骤手动修改。  
      如果有整个node\_modules的，则将mynode下的node\_modules替换掉。

  5. 安装bower&grunt
```
   npm install bower -g  
   npm install grunt-cli -g
```
  6. 编译代码，进入explorer代码目录 
``` 
  npm install  
  bower install （root用户：bower install --allow-root）  
  grunt compile
```
5\. 修改配置文件

1.  修改node配置文件qtumcore-node.json，文件位于mynode目录。  
```
      {  
      "network": "livenet",（测试网为：testnet）  
      "port": 3001,*node服务端口，建议改为80为浏览器访问默认端口  
      "services": \[  
      "qtumd",  
      "qtum-insight-api",  
      "qtum-explorer",  
      "web"  
      \],  
      "servicesConfig": {  
      "qtum-explorer": {  
      "apiPrefix": "qtum-insight-api",  
      "routePrefix": "woc-explorer",*从浏览器访问时的路由前缀，可以删除或者修改为对应的应用名称  
      "nodemapLink": "[https://qtum.org/en/nodemap](https://qtum.org/en/nodemap)"  
      },  
      "qtum-insight-api": {  
      "routePrefix": "qtum-insight-api",  
      "rateLimiterOptions": {  
      "whitelist": \[  
      "123.456.12.34",  
      "::ffff:123.456.12.34"  
      \],  
      "whitelistLimit": 9999999,  
      "limit": 200,  
      "interval": 60000,  
      "banInterval": 3600000  
      },  
      "db": {  
      "host": "127.0.0.1",  
      "port": "27017",  
      "database": "qtum-api-livenet",  
      "user": "",  
      "password": ""  
      },  
      "erc20": {  
      "updateFromBlockHeight": 0  
      }  
      },  
      "qtumd": {  
      "spawn": {  
      "datadir": "/root/.gzh",*后台节点程序的数据路径  
      "exec": "/root/gzh/src/gzhd"  
      }  
      }  
      }  
     }  
```
     2. 跑一次gzh-bitcore 中的src下主程序 gzhd ，在/下生成 .gzh目录  
     3. 修改后台节点配置文件gzh.conf (/.gzh 目录下，没有就自己创建）*

6\. 修改node配置文件

1.  修改nodejs  
     mynode/node\_modules/bignumber.js/bignumber.js和mynode/node\_modules/web3/node\_modules/bignumber.js/bignumber.js  
     if ( ERRORS && str.replace( /^0\\.0\*|\\./, '' ).length > 15 ) 中的15 改成18  
     if ( num && ERRORS && len > 15 && ( n > MAX\_SAFE\_INTEGER || n !== mathfloor![thumb_down](/resources/icons/silk/thumb_down.png?cache-version=1597744068000) ) ) 中的15改成18

 如果地址前缀有变动，则根据节点代码src/chainparams.cpp中的  
 base58Prefixes\[PUBKEY\_ADDRESS\] = std::vector<unsigned char>(1,58);  
 例如通过58变成16进制得到的3a  
 ./node\_modules/qtum-explorer/public/js/vendors.js  
 ./node\_modules/bitcore-lib/test/networks.js  
 ./node\_modules/bitcore-lib/lib/networks.js  
 ./node\_modules/qtumcore-lib/test/networks.js  
 ./node\_modules/qtumcore-lib/lib/networks.js  
 在上面5个文件的相应网络下，比如主网 
``` 
 addNetwork({  
  name: 'livenet',  
  alias: 'mainnet',  
  pubkeyhash: 0x26,*base58check编码前的地址前缀，与后台节点代码一致  
  privatekey: 0x80,  
  scripthash: 0x32,  
  xpubkey: 0x0488b21e,  
  xprivkey: 0x0488ade4,  
  networkMagic: 0xf9beb4d9,  
  port: 8333,  
  dnsSeeds: \[  
  \]  
 });*
```
 在0x26的位置，更改外0x3a。

   2. 启动node  
 #（npm bin为qtumcore-node实际安装目录，例如/root/node\_modules/qtumcore-node/bin）  
 #启动命令需要在mynode目录执行  
 1.#调试可以直接在前端启动，如果终端关闭node服务也会关闭  
 $(npm bin) /root/node\_modules/qtumcore-node/bin/qtumcore-node start  
 2.#如果需要启动到后台,可以使用nohup  
 nohup $(npm bin) nohup /home/mynode/node\_modules/qtumcore-node/bin/qtumcore-node start &  
 3.如果希望node永远在线，可以使用node的forever:  
 npm install forever  
 ./node\_modules/forever/bin/forever start /home/mynode/node\_modules/qtumcore-node/bin/qtumcore-node start config /home/mynode/qtumcore-node.json

