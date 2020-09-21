#!/bin/bash
yum -y install sshpass

# confirm the user of the operation 
echo "The current user is `whoami`"

# 1.generate the key pair
# 判断key是否已经存在，如果不存在就生成新的key
if [ -f ~/.ssh/id_rsa ];then
    echo "rsa ssh-key file already exists" /bin/true
else
    echo "rsa ssh-key file does not exists"
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -P "" >/dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "generate rsa ssh-key" /bin/true
    else
        echo "generate rsa ssh-key" /bin/false
        exit 1
    fi
fi

# 2.distribution public key
for host in $(cat ./ssh-ip | grep -v "#" | grep -v ";" | grep -v "^$")
do
    ip=$(echo ${host} | cut -f1 -d ":")
    password=$(echo ${host} | cut -f2 -d ":")
    user=$(echo ${host} | cut -f3 -d ":")
    port_ip=$(echo ${user}@${ip})
    sshpass -p "${password}" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${port_ip}
    sshpass -p "${password}" ssh ${port_ip} "chmod 700 ~/.ssh;chmod 600 ~/.ssh/authorized_keys"
    if [ $? -eq 0 ];then
        echo "${ip} distribution public key" /bin/true
    else
        echo "${ip} distribution public key" /bin/false
        exit 1
    fi
done

