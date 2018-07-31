#!/bin/bash

git clone https://git.llvm.org/git/llvm.git/

cd llvm/tools

git clone https://git.llvm.org/git/clang.git/

cd ../projects

git clone https://git.llvm.org/git/compiler-rt.git/
git clone https://git.llvm.org/git/openmp.git/
git clone https://git.llvm.org/git/libcxx.git/
git clone https://git.llvm.org/git/libcxxabi.git/

cd ..

mkdir build

cd build

export LD_LIBRARY_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_LIBRARY_PATH
export LD_RUN_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_RUN_PATH

CC=/root/newapi/api_server/dedal/toolchains/bin/gcc CXX=/root/newapi/api_server/dedal/toolchains/bin/g++ /root/newapi/api_server/dedal/toolchains/bin/cmake .. -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,/root/newapi/api_server/dedal/toolchains/lib64 -L/root/newapi/api_server/dedal/toolchains/lib64"
