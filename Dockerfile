FROM haproxy:alpine
RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && apk add --no-cache --update tini runit inotify-tools
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY docker-entrypoint.sh /
COPY inotify /etc/service/inotify
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]