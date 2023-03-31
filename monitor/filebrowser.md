filebrowser工具
安装
依次执行：
wget https://github.com/filebrowser/filebrowser/releases/download/v2.23.0/linux-amd64-filebrowser.tar.gz
tar vxzf ./linux-amd64-filebrowser.tar.gz
./filebrowser -a 0.0.0.0 -p 8081 -r /
后台运行：nohup ./filebrowser -a 0.0.0.0 -p 8081 -r / >/dev/null 2>&1 &

说明：-r 表示挂载的目录

登录
http://your_ip:8081/login
账号：admin  密码：admin