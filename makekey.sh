
#参数
pwd=asd123
domain=api.solarsystemscope.com

# 替换域名
sed -i "s/DNS.1 = .\+$/DNS.1 = ${domain}/g;s/commonName_default = .\+$/DNS.1 = ${domain}/g" _cfg/openssl.cnf

mkdir output

#--创建自己的CA机构
#为CA生成私钥
openssl genrsa -passout "pass:${pwd}" -out output/ca-key.pem -des 2048

#通过CA私钥生成CSR
openssl req -passin "pass:${pwd}" -new -days 122 -key output/ca-key.pem -config _cfg/openssl.cnf -out output/ca-csr.pem

#通过CSR文件和私钥生成CA证书
openssl x509 -passin "pass:${pwd}" -req -days 122 -in output/ca-csr.pem -signkey output/ca-key.pem -out output/ca-cert.pem

#--创建服务器端证书
#为服务器生成私钥
openssl genrsa -passout "pass:${pwd}" -out output/server-key.pem -des 2048

#利用服务器私钥文件服务器生成CSR
openssl req -passin "pass:${pwd}" -new -days 122 -key output/server-key.pem -config _cfg/openssl.cnf -out output/server-csr.pem

#通过服务器私钥文件和CSR文件生成服务器证书
openssl x509 -passin "pass:${pwd}" -req -days 122 -CA output/ca-cert.pem -CAkey output/ca-key.pem -CAcreateserial -in output/server-csr.pem -out output/server-cert.pem -extensions v3_req -extfile _cfg/openssl.cnf


#--创建客户端证书

#生成客户端私钥
openssl genrsa -passout "pass:${pwd}" -out output/client-key.pem -des 2048

#利用私钥生成CSR
openssl req -passin "pass:${pwd}" -days 122 -new -key output/client-key.pem -config _cfg/openssl.cnf -out output/client-csr.pem

#生成客户端证书
openssl x509 -passin "pass:${pwd}" -req -days 122 -CA output/ca-cert.pem -CAkey output/ca-key.pem -CAcreateserial -in output/client-csr.pem -out output/client-cert.pem

