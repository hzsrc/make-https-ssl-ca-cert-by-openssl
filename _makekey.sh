#!/bin/bash

#mkdir -p ./demoCA/{private,newcerts}
#touch ./demoCA/index.txt
#echo 01 > ./demoCA/serial



 #创建自己的CA机构
#为CA生成私钥
openssl genrsa -out ca-key.pem -des 2048

#通过CA私钥生成CSR
openssl req -new -days 122 -key ca-key.pem -config ./_cfg/openssl.cnf -out ca-csr.pem

#通过CSR文件和私钥生成CA证书
openssl x509 -req -days 122 -in ca-csr.pem -signkey ca-key.pem -out ca-cert.pem
 
 
 #创建服务器端证书

#为服务器生成私钥
openssl genrsa -out server-key.pem 2048

#利用服务器私钥文件服务器生成CSR
openssl req -new -days 122 -key server-key.pem -config ./_cfg/openssl.cnf -out server-csr.pem

#通过服务器私钥文件和CSR文件生成服务器证书
openssl x509 -req -days 122 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -in server-csr.pem -out server-cert.pem -extensions v3_req -extfile ./_cfg/openssl.cnf
 
 
 #创建客户端证书

#生成客户端私钥
openssl genrsa -out client-key.pem 2048

#利用私钥生成CSR
openssl req -days 122 -new -key client-key.pem -config ./_cfg/openssl.cnf -out ./output/client-csr.pem

#生成客户端证书
openssl x509 -req -days 122 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -in client-csr.pem -out ./output/client-cert.pem

