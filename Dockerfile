FROM haproxy
MAINTAINER Stéphane Cottin <stephane.cottin@vixns.com>
RUN mkdir /run/haproxy

COPY haproxy-run /haproxy-run
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
CMD ["/haproxy-run"]
