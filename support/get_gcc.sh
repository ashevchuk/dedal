#!/bin/bash

yum install glibc-devel
yum install glibc-devel.i686

wget https://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
wget https://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2.sig
wget https://ftp.gnu.org/gnu/gnu-keyring.gpg

signature_invalid=`gpg --verify --no-default-keyring --keyring ./gnu-keyring.gpg gcc-4.8.2.tar.bz2.sig`

if [ $signature_invalid ]; then echo "Invalid signature" ; exit 1 ; fi

tar -xvjf gcc-4.8.2.tar.bz2
cd gcc-4.8.2
./contrib/download_prerequisites
cd ..
mkdir gcc-4.8.2-build
cd gcc-4.8.2-build
$PWD/../gcc-4.8.2/configure --prefix=/root/newapi/api_server/dedal/toolchains --enable-languages=c,c++
make -j$(nproc)
make install
