FROM centos:7

ENV LANG en_US.utf8
ENV NGINX_VERSION 1.20.2
ENV GMSSL_VERSION 1.1_b4

WORKDIR /opt

RUN set -ex \
    && groupadd --system --gid 101 nginx \
    && adduser --system --gid nginx --no-create-home --home /var/cache/nginx --comment "nginx user" --shell /sbin/nologin --uid 101 nginx \
    && yum -y install wget gcc make pcre-devel zlib-devel \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "LANG=$LANG" > /etc/locale.conf \
    && wget https://www.gmssl.cn/gmssl/Tool_Down?File=gmssl_openssl_${GMSSL_VERSION}.tar.gz -O /opt/gmssl_openssl_${GMSSL_VERSION}.tar.gz \
    && tar xf /opt/gmssl_openssl_${GMSSL_VERSION}.tar.gz -C /usr/local \
    && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar xf nginx-${NGINX_VERSION}.tar.gz \
    && sed -i 's@$OPENSSL/.openssl/@$OPENSSL/@g' /opt/nginx-${NGINX_VERSION}/auto/lib/openssl/conf \
    && cd /opt/nginx-${NGINX_VERSION} \
    && ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-openssl='/usr/local/gmssl' --with-cc-opt='-I/usr/local/gmssl/include' --with-ld-opt='-lm' \
    && make install \
    && mkdir -p /usr/share/nginx \
    && mv /etc/nginx/html /usr/share/nginx \
    && cd /opt \
    && rm -rf /opt/nginx-${NGINX_VERSION} \
    && rm -f /opt/*.tar.gz /etc/nginx/nginx.conf /etc/nginx/*.default \
    && yum clean all \
    && rm -rf /var/tmp/yum*

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
