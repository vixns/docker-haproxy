FROM vixns/base-runit
MAINTAINER Stéphane Cottin <stephane.cottin@vixns.com>

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends --auto-remove -y haproxy=1.5.11 && \
  rm -rf /var/lib/apt/lists/* 

RUN mkdir /run/haproxy
ADD haproxy-run /etc/service/haproxy/run