#for 医疗项目

# download
cd /root/
#wget -c https://www.openssl.org/source/openssl-1.1.1n.tar.gz


# compile & install
tar zxvf openssl-1.1.1n.tar.gz
cd openssl-1.1.1n
./config && make && make install
#说明：make过程时间较长。

# if fail, then exit
[ $? -ne 0 ] && exit 0


# copy
cd /root/openssl-1.1.1n
cp libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/
cp libssl.so.1.1 /usr/lib/x86_64-linux-gnu/

#验证：/usr/local/bin/openssl version


# link
mv /usr/bin/openssl /usr/bin/openssl.bak
ln -s /usr/local/bin/openssl /usr/bin/openssl


# final check
openssl version
