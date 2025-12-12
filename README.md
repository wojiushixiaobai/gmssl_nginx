# Tongsuo

- [铜锁 / Tongsuo](https://www.tongsuo.net/)

铜锁开源社区目前不直接提供有偿的商业服务, 可以通过 [天威诚信](https://www.itrus.com.cn/)、问天量子、[阿里云](https://www.aliyun.com/)、BTQ、蚂蚁集团 等生态合作方采购数字证书

运行容器
```sh
docker run --name nginx -d --restart=always \
  -p 80:80 -p 443:443 \
  -v /opt/sslkey:/etc/nginx/sslkey \
  -v /opt/default.conf:/etc/nginx/conf.d/default.conf \
  wojiushixiaobai/tongsuo_nginx:latest
```

# WoTrus 证书使用说明

- [沃通 SSL 证书](https://www.wosign.com/Docdownload/)

获取 ssl 证书后解压到服务器
```sh
ll /opt/sslkey
```
```sh
总用量 12
-rw-r--r--. 1 root root 3048 12月  2 19:07 test.domain.localhost_sm2_encrypt_bundle.crt
-rw-r--r--. 1 root root  227 12月  2 19:07 test.domain.localhost_SM2.key
-rw-r--r--. 1 root root 3048 12月  2 19:07 test.domain.localhost_sm2_sign_bundle.crt
```

生成 nginx 配置文件
```sh
vi /opt/default.conf
```

```nginx
server {
    listen 80;
    server_name test.domain.localhost;  # 自行修改成你的域名
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name test.domain.localhost;  # 自行修改成你的域名

    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers ECC-SM4-SM3:ECDH:AESGCM:HIGH:MEDIUM:!RC4:!DH:!MD5:!aNULL:!eNULL;
    ssl_verify_client off;
    ssl_session_timeout 5m;
    ssl_prefer_server_ciphers on;

    ssl_certificate sslkey/test.domain.localhost_sm2_sign_bundle.crt;      # 配置国密签名证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost_SM2.key;

    ssl_certificate sslkey/test.domain.localhost_sm2_encrypt_bundle.crt;   # 配置国密加密证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost_SM2.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

运行容器
```sh
docker run --name nginx -d --restart=always \
  -p 80:80 -p 443:443 \
  -v /opt/sslkey:/etc/nginx/sslkey \
  -v /opt/default.conf:/etc/nginx/conf.d/default.conf \
  wojiushixiaobai/wotrus_nginx:latest
```

# GDCA 证书使用说明

[GDCA 数安时代](https://www.trustauth.cn/)

```sh
ll /opt/sslkey
```
```sh
总用量 12
-rw-r--r--. 1 root root 3048 12月  2 19:07 test.domain.localhost_encrypt_chain.crt
-rw-r--r--. 1 root root  227 12月  2 19:07 test.domain.localhost.key
-rw-r--r--. 1 root root 3048 12月  2 19:07 test.domain.localhost_sign_chain.crt
```

```sh
vi /opt/default.conf
```

```nginx
server {
    listen 80;
    server_name test.domain.localhost;  # 自行修改成你的域名
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name test.domain.localhost;  # 自行修改成你的域名

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-SM2-SM4-SM3:ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!3DES:!aNULL:!MD5:!ADH:!RC4;
    ssl_verify_client off;
    ssl_session_timeout 5m;
    ssl_prefer_server_ciphers on;

    ssl_certificate sslkey/test.domain.localhost_sign_chain.crt;      # 配置国密签名证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost.key;

    ssl_certificate sslkey/test.domain.localhost_encrypt_chain.crt;   # 配置国密加密证书/私钥
    ssl_certificate_key sslkey/test.domain.localhost.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

```sh
docker run --name nginx -d --restart=always \
  -p 80:80 -p 443:443 \
  -v /opt/sslkey:/etc/nginx/sslkey \
  -v /opt/default.conf:/etc/nginx/conf.d/default.conf \
  wojiushixiaobai/trustauth_nginx:latest
```

# GMSSL 证书使用说明

[国密 SSL 实验室](https://www.gmssl.cn/)

> 试用版本每季度末失效，国密 SSL 协议会异常或者错误，需更新库，重新链接。请勿用于正式/生产环境

```sh
ll /opt/sslkey
```

```sh
总用量 72
-rw-r--r--. 1 root root    8 12月  2 16:33 password.txt
-rw-r--r--. 1 root root 3161 12月  2 16:33 sm2.test.domain.localhost.both.pfx
-rw-r--r--. 1 root root  525 12月  2 16:33 sm2.test.domain.localhost.enc.cer
-rw-r--r--. 1 root root  765 12月  2 16:33 sm2.test.domain.localhost.enc.crt.pem
-rw-r--r--. 1 root root  150 12月  2 16:33 sm2.test.domain.localhost.enc.key
-rw-r--r--. 1 root root  520 12月  2 16:33 sm2.test.domain.localhost.enc.key.crypted.b64
-rw-r--r--. 1 root root  388 12月  2 16:33 sm2.test.domain.localhost.enc.key.crypted.bin
-rw-r--r--. 1 root root  227 12月  2 16:33 sm2.test.domain.localhost.enc.key.p8
-rw-r--r--. 1 root root  258 12月  2 16:33 sm2.test.domain.localhost.enc.key.pem
-rw-r--r--. 1 root root  962 12月  2 16:33 sm2.test.domain.localhost.enc.pfx
-rw-r--r--. 1 root root  524 12月  2 16:33 sm2.test.domain.localhost.sig.cer
-rw-r--r--. 1 root root  765 12月  2 16:33 sm2.test.domain.localhost.sig.crt.pem
-rw-r--r--. 1 root root  150 12月  2 16:33 sm2.test.domain.localhost.sig.key
-rw-r--r--. 1 root root  227 12月  2 16:33 sm2.test.domain.localhost.sig.key.p8
-rw-r--r--. 1 root root  258 12月  2 16:33 sm2.test.domain.localhost.sig.key.pem
-rw-r--r--. 1 root root  961 12月  2 16:33 sm2.test.domain.localhost.sig.pfx
-rw-r--r--. 1 root root  725 12月  2 16:33 sm2.oca.pem
-rw-r--r--. 1 root root  684 12月  2 16:33 sm2.rca.pem
```

```sh
vi /opt/default.conf
```

```nginx
server {
    listen 80;
    server_name test.domain.localhost;  # 自行修改成你的域名
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name test.domain.localhost;  # 自行修改成你的域名

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:AES128-SHA:DES-CBC3-SHA:ECC-SM4-CBC-SM3:ECC-SM4-GCM-SM3;
    ssl_verify_client off;

    ssl_certificate sslkey/sm2.test.domain.localhost.sig.crt.pem;      # 配置国密签名证书/私钥
    ssl_certificate_key sslkey/sm2.test.domain.localhost.sig.key.pem;

    ssl_certificate_key sslkey/sm2.test.domain.localhost.enc.key.pem;  # 配置国密加密证书/私钥
    ssl_certificate sslkey/sm2.test.domain.localhost.enc.crt.pem;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

```sh
docker run --name nginx -d --restart=always \
  -p 80:80 -p 443:443 \
  -v /opt/sslkey:/etc/nginx/sslkey \
  -v /opt/default.conf:/etc/nginx/conf.d/default.conf \
  wojiushixiaobai/gmssl_nginx:latest
```
