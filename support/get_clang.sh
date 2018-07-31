#!/bin/bash

export PATH=/root/newapi/api_server/dedal/toolchains/bin:$PATH
export LD_LIBRARY_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_LIBRARY_PATH
export LD_RUN_PATH=/root/newapi/api_server/dedal/toolchains/lib/../lib64:$LD_RUN_PATH

CC=/root/newapi/api_server/dedal/toolchains/bin/gcc CXX=/root/newapi/api_server/dedal/toolchains/bin/g++  ./install-clang -b Release -C -c -j 8 /root/newapi/api_server/dedal/toolchains
