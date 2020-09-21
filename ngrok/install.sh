#!/bin/bash

git clone https://github.com/tutumcloud/ngrok.git ngrok

cd ngrok

mkdir cert

cd cert

export NGROK_DOMAIN="cherrytest.yingtaoplay.com"

openssl genrsa -out rootCA.key 2048

openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem

openssl genrsa -out device.key 2048

openssl req -new -key device.key -subj "/CN=$NGROK_DOMAIN" -out device.csr

openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000


cp rootCA.pem ../assets/client/tls/ngrokroot.crt

cp device.crt ../assets/server/tls/snakeoil.crt

cp device.key ../assets/server/tls/snakeoil.key

#make release-server release-client

#注意事项:root执行，配置 *.bbb.aaa.com 解析
#nginx 反向代理
