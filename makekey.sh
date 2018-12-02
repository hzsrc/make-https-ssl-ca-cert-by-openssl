
#参数
echo 'set a cert password:'
read pwd
echo 'input your website domain:'
read domain
domain=${domain:-api.solarsystemscope.com}

# 替换域名
sed -i "s/DNS.1 = .\+$/DNS.1 = ${domain}/g" _cfg/openssl.cnf
sed -i "s/commonName_default = .\+$/commonName_default = ${domain}/g" _cfg/openssl.cnf

mkdir output
rm output/*

#--创建自己的CA机构
# 为CA生成私钥
openssl genrsa -passout "pass:${pwd}" -out output/ca.key 2048

#通过CA私钥生成CSR
openssl req -passin "pass:${pwd}" -new -days 3650 -key output/ca.key -batch -config _cfg/openssl.cnf -out output/ca.csr

#通过CSR文件和私钥生成CA证书
openssl x509 -passin "pass:${pwd}" -req -days 3650 -signkey output/ca.key -in output/ca.csr -out output/ca.crt





#--创建服务器端证书
#为服务器生成私钥
openssl genrsa -passout "pass:${pwd}" -out output/server.key 2048

#利用服务器私钥文件服务器生成【证书请求CSR文件】
#Common Name填写主要域名，这个域名要在DNS.XX里
#server.csr 这个文件就是要拿给CA厂商签名的，server.key这个私钥文件自己保存好。拿给厂商签名后厂商会用他们的根证书签名这个CSR文件，生成你服务器可用证书server.crt给你. https://www.cnblogs.com/liqingjht/p/6267563.html
openssl req -passin "pass:${pwd}" -new -days 3650 -key output/server.key -batch -config _cfg/openssl.cnf -out output/server.csr

#用自己的CA签名：通过服务器私钥文件和CSR文件生成服务器证书
openssl x509 -passin "pass:${pwd}" -req -days 3650 -CA output/ca.crt -CAkey output/ca.key -CAcreateserial -in output/server.csr -out output/server.crt -extensions v3_req -extfile _cfg/openssl.cnf

#--创建客户端证书

#生成客户端私钥
#openssl genrsa -passout "pass:${pwd}" -out output/client.key 2048

#利用私钥生成CSR
#openssl req -batch -passin "pass:${pwd}" -days 3650 -new -key output/client.key -config _cfg/openssl.cnf -out output/client.csr

#生成客户端证书
#openssl x509 -passin "pass:${pwd}" -req -days 3650 -CA output/ca.crt -CAkey output/ca.key -CAcreateserial -in output/client.csr -out output/client.crt



# for https
cd output
zip ssl.zip ca.crt server.crt server.key
sz ssl.zip


