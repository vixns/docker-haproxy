FROM debian:stretch

ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.7
ENV HAPROXY_MD5 a046ed63b00347bd367b983529dd541f

# see http://sources.debian.net/src/haproxy/1.5.8-1/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN \
	apt-get update && apt-get install -y libssl1.0.2 libpcre3 liblua5.3-0 --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
 	&& buildDeps='curl gcc libc6-dev libpcre3-dev liblua5.3-dev libssl-dev make' \
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

COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]