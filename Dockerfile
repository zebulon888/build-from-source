FROM	opensuse/tumbleweed:latest

RUN	zypper -n dup \
	&& zypper install -y --no-recommends curl ca-certificates gpg2 openssl \
	patterns-devel-base-devel_basis python3-pip nano siege apache2-utils iputils \
	&& zypper clean -a \
	&& pip install --upgrade pip \
	&& pip install supervisor

WORKDIR /srv/www/htdocs

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["bash" ]
