FROM    opensuse/tumbleweed:latest

WORKDIR /tmp

# get the build packages
RUN     zypper -n dup \
        && zypper install -y --no-recommends curl ca-certificates gpg2 openssl libopenssl-devel \
        patterns-devel-base-devel_basis pcre-devel libopenssl-devel gd-devel libxml2-devel libxslt-devel pcre zlib wget nano iputils \
	ncurses ncurses-devel libmaxminddb-devel libmaxminddb0 gettext gettext-devel \
        && zypper clean -a && wget https://nginx.org/download/nginx-1.17.7.tar.gz && tar -xzvf nginx-1.17.7.tar.gz \
	&& wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1d.tar.gz && tar zvxf OpenSSL_1_1_1d.tar.gz 

# build nginx
RUN     cd nginx-1.17.7 \
        && ./configure --prefix=/srv/www/nginx --sbin-path=/usr/bin/nginx --modules-path=/etc/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/srv/www/nginx/tmp/ --http-proxy-temp-path=/srv/www/nginx/proxy/ \
	--http-fastcgi-temp-path=/srv/www/nginx/fastcgi/ --http-uwsgi-temp-path=/srv/www/nginx/uwsgi/ \
	--http-scgi-temp-path=/srv/www/nginx/scgi/ --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock \
	--with-http_ssl_module --with-http_v2_module --with-pcre --with-ipv6 --with-http_xslt_module \
	--with-http_image_filter_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-stream \
	--with-stream_ssl_module --with-mail --with-mail_ssl_module --with-http_gzip_static_module --with-http_gunzip_module \
	--with-http_stub_status_module --with-openssl=/tmp/openssl-OpenSSL_1_1_1d \
	&& make && make install

# build goaccess
RUN 	cd /tmp && wget https://tar.goaccess.io/goaccess-1.3.tar.gz && tar -xzvf goaccess-1.3.tar.gz && cd goaccess-1.3/ \
	&& ./configure --enable-utf8 --with-openssl --enable-geoip=mmdb \
	&& make && make install

STOPSIGNAL SIGTERM

CMD ["/bin/bash" ]
