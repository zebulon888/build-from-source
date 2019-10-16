FROM    opensuse/tumbleweed:latest

WORKDIR /tmp
RUN     zypper -n dup \
        && zypper install -y --no-recommends curl ca-certificates gpg2 openssl \
        patterns-devel-base-devel_basis pcre-devel libopenssl-devel wget nano iputils \
        && zypper clean -a && wget https://nginx.org/download/nginx-1.17.4.tar.gz \
        && tar -xzvf nginx-1.17.4.tar.gz

RUN     cd nginx-1.17.4 \
        && ./configure --prefix=/srv/www/nginx --sbin-path=/usr/bin/nginx --modules-path=/etc/nginx/modules \
	--conf-path=/etc/nginx --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --with-http_ssl_module --with-http_v2_module \
	--with-pcre --with-ipv6 && make && make install

STOPSIGNAL SIGTERM

CMD ["/bin/bash" ]
