## Qt 钱包
- Linux ：生成在src/qt下

- Window钱包:
```
64位：
sudo apt-get install g++-mingw-w64-x86-64 mingw-w64-x86-64-dev
PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*g') # strip out problematic Windows %PATH% imported var
cd depends
make HOST=x86_64-w64-mingw32
cd ..
./autogen.sh # not required when building from tarball
CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure prefix=/

make clean
make -j30
```

- Mac钱包:
```
./autogen.sh
./configure
make
make deploy
```