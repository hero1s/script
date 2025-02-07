#!/bin/bash

# 检查是否提供了版本参数
if [ -z "$1" ]; then
    echo "请提供 devtoolset 的版本号，例如: $0 10"
    exit 1
fi

VERSION=$1

# 安装必要的软件包
echo "正在安装 centos-release-scl..."
sudo yum install centos-release-scl -y || { echo "安装 centos-release-scl 失败"; exit 1; }

echo "正在安装 devtoolset-${VERSION}-toolchain..."
sudo yum install devtoolset-${VERSION}-toolchain -y || { echo "安装 devtoolset-${VERSION}-toolchain 失败"; exit 1; }

# 启用 devtoolset 环境
echo "正在启用 devtoolset-${VERSION} 环境..."
scl enable devtoolset-${VERSION} bash || { echo "启用 devtoolset-${VERSION} 环境失败"; exit 1; }

# 将 devtoolset 环境配置持久化到 ~/.bash_profile
echo "正在将 devtoolset-${VERSION} 环境配置持久化到 ~/.bash_profile..."
if ! grep -q "source /opt/rh/devtoolset-${VERSION}/enable" ~/.bash_profile; then
    echo "source /opt/rh/devtoolset-${VERSION}/enable" >> ~/.bash_profile
else
    echo "devtoolset-${VERSION} 环境配置已存在，跳过写入"
fi

# 重新加载 ~/.bash_profile
echo "正在重新加载 ~/.bash_profile..."
source ~/.bash_profile || { echo "重新加载 ~/.bash_profile 失败"; exit 1; }

# 确保 devtoolset 环境已启用
echo "正在验证 devtoolset-${VERSION} 环境是否已启用..."
source /opt/rh/devtoolset-${VERSION}/enable || { echo "启用 devtoolset-${VERSION} 环境失败"; exit 1; }

echo "所有步骤完成，devtoolset-${VERSION} 环境已成功启用。"



#静态编译
yum install glibc-static
yum install glibc-static libstdc++-static
