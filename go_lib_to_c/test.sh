set -xe
#添加动态库搜索路径
export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH

g++ ./test.cpp -o testgo -L ./lib -ltest

./testgo