FROM debian:jessie
MAINTAINER Stéphane Cottin <stephane.cottin@vixns.com>
RUN echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list && apt-get update && apt-get install -y libssl1.0.0 libpcre3 liblua5.3-0 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.5
ENV HAPROXY_MD5 5290f278c04e682e42ab71fed26fc082

# see http://sources.debian.net/src/haproxy/1.5.8-1/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN buildDeps='curl gcc libc6-dev libpcre3-dev liblua5.3-dev libssl-dev make' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
	&& echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
	&& mkdir -p /usr/src/haproxy \
	&& tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
	&& rm haproxy.tar.gz \
	&& make -C /usr/src/haproxy \
		TARGET=linux2628 \
		USE_PCRE=1 PCREDIR= \
		USE_OPENSSL=1 \
		USE_ZLIB=1 \
		USE_LUA=1 LUA_INC=/usr/include/lua5.3 \
		all \
		install-bin \
	&& mkdir -p /etc/haproxy \
	&& mkdir -p /run/haproxy \
	&& cp -R /usr/src/haproxy/examples/errorfiles /etc/haproxy/errors \
	&& rm -rf /usr/src/haproxy \
	&& apt-get purge -y --auto-remove $buildDeps 

COPY haproxy-run /haproxy-run
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
CMD ["/haproxy-run"]
