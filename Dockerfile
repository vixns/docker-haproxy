FROM vixns/base-runit
MAINTAINER Stéphane Cottin <stephane.cottin@vixns.com>

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends --auto-remove -y haproxy incron && \
  rm -rf /var/lib/apt/lists/* 

RUN mkdir /run/haproxy

RUN echo 'root' >> /etc/incron.allow
ADD incron.root /var/spool/incron/root
ADD incron-run /etc/service/incron/run
ADD haproxy-run /etc/service/haproxy/run