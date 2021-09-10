#!/bin/bash
set -xe

#Linux之CentOS 7通过yum安装gcc
yum install centos-release-scl -y
yum install devtoolset-9-toolchain -y
scl enable devtoolset-9 bash
echo "source /opt/rh/devtoolset-9/enable" >> ~/.bash_profile
source ~/.bash_profile
source /opt/rh/devtoolset-9/enable


#静态编译
yum install glibc-static
yum install glibc-static libstdc++-static
