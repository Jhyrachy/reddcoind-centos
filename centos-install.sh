#!/bin/bash

if [ ! -x /usr/bin/wget ] ; then
 echo "for some silly reason, wget is not executable.  Please fix this (as root do chmod +x /usr/bin/wget) and try again"
 exit
fi

USERNAME=`whoami`
cd ~
mkdir Reddcoin
cd Reddcoin
mkdir Libraries
mkdir Trunk
mkdir Deps
cd Libraries

wget http://leveldb.googlecode.com/files/leveldb-1.15.0.tar.gz
tar zxvf leveldb-1.15.0.tar.gz
cd leveldb-1.15.0
make
cd ..

wget -qO- http://downloads.sourceforge.net/boost/boost_1_55_0.tar.bz2 | tar xjv
cd boost_1_55_0
./bootstrap.sh
./bjam --prefix=/home/$USERNAME/Reddcoin/Deps link=static runtime-link=static install
cd ..

wget -qO- http://www.openssl.org/source/openssl-1.0.0g.tar.gz | tar xzv
cd openssl-1.0.0g
if uname -a | grep -q x86_64 ; then
 ./Configure no-shared --prefix=/home/$USERNAME/Reddcoin/Deps --openssldir=/home/$USERNAME/Reddcoin/Deps/openssl linux-x86_64
else
 ./Configure no-shared --prefix=/home/$USERNAME/Reddcoin/Deps --openssldir=/home/$USERNAME/Reddcoin/Deps/openssl linux-generic32
fi
#make depend
make
make install
cd ..

wget -qO- http://download.oracle.com/berkeley-db/db-5.1.19.tar.gz | tar xzv
cd db-5.1.19/build_unix
../dist/configure --prefix=/home/$USERNAME/Reddcoin/Deps/ --enable-cxx
make
make install
cd ../..

mkdir reddcoin-master
cd reddcoin-master
wget -qO- https://github.com/reddcoin/reddcoin/tarball/master --no-check-certificate | tar xzv --strip-components 1
cd src
#cp -vap ~$USERNAME/makefile.new .
cat /home/$USERNAME/makefile.new | sed s/kjj/$USERNAME/g > makefile.new
make -f makefile.new reddcoind
cp -vap reddcoind /home/$USERNAME/
cd ~
