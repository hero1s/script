#!/bin/sh

db_user="root"
db_passwd="e23456"

# 保存数据库结构
all_dbs=("cherry" "cherry_config" "cherry_log" "cherry_backend")

for dbname in ${all_dbs[*]}
do
    mysqldump -u$db_user -p$db_passwd $dbname -d > ./${dbname}.sql
done


# 保存数据库数据
save_dbs=("cherry_config" "cherry_backend")
for dbname in ${save_dbs[*]}
do
    mysqldump -u$db_user -p$db_passwd $dbname > ./${dbname}_data.sql
done


