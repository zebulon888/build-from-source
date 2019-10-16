FROM    opensuse/tumbleweed:latest

WORKDIR /tmp

RUN     zypper -n dup \
        && zypper install -y --no-recommends curl ca-certificates gpg2 openssl \
        patterns-devel-base-devel_basis pcre-devel libopenssl-devel pcre zlib wget nano iputils \
        && zypper clean -a && wget https://nginx.org/download/nginx-1.17.4.tar.gz \
        && tar -xzvf nginx-1.17.4.tar.gz

RUN     cd nginx-1.17.4 \
        && ./configure --prefix=/srv/www/nginx --sbin-path=/usr/bin/nginx --modules-path=/etc/nginx/modules \
	--conf-path=/etc/nginx --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/srv/www/nginx/tmp/ --http-proxy-temp-path=/srv/www/nginx/proxy/ \
	--http-fastcgi-temp-path=/srv/www/nginx/fastcgi/ --http-uwsgi-temp-path=/srv/www/nginx/uwsgi/ \
	--http-scgi-temp-path=/srv/www/nginx/scgi/ --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock \
	--with-http_ssl_module --with-http_v2_module --with-pcre --with-ipv6 --with-http_xslt_module \
	--with-http_image_filter_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-stream \
	--with-stream_ssl_module --with-mail --with-mail_ssl_module --with-http_gzip_static_module --with-http_gunzip_module \
	--with-http_stub_status_module --with-openssl \
	&& make && make install

STOPSIGNAL SIGTERM

CMD ["/bin/bash" ]
