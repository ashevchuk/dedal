#!/bin/bash

wget https://cmake.org/files/v3.12/cmake-3.12.0.tar.gz

tar -zxvf cmake-3.12.0.tar.gz

cd cmake-3.12.0

export LD_LIBRARY_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_LIBRARY_PATH
export LD_RUN_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_RUN_PATH

CC=/root/newapi/api_server/dedal/toolchains/bin/gcc CXX=/root/newapi/api_server/dedal/toolchains/bin/g++ ./bootstrap --prefix=/root/newapi/api_server/dedal/toolchains --parallel=$(nproc)

CC=/root/newapi/api_server/dedal/toolchains/bin/gcc CXX=/root/newapi/api_server/dedal/toolchains/bin/g++ make

make install
