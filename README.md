# Haproxy docker image

[![](https://badge.imagelayers.io/vixns/haproxy:latest.svg)](https://imagelayers.io/?images=vixns/haproxy:latest 'Get your own badge on imagelayers.io')

Yet another dockerized haproxy, built on top of debian jessie, with lua support and zero downtime reload.

## Usage:

### Basic

#### configuration test

	docker run --rm -v myhaproxyconfigdir:/etc/haproxy vixns/haproxy haproxy -c -f /etc/haproxy/haproxy.cfg

#### starting

	docker run --rm --restart=always --name haproxy -d -p 80:80 -p 9302:9302 -p 443:443 -v myhaproxyconfigdir:/etc/haproxy vixns/haproxy
	
#### zero downtime reload

	docker kill -s HUP haproxy


### With consul template

We're using this image in our mesos/marathon clusters along consul-template and docker labels.

The docker container is launched by marathon, a command line equivalent would be
	
	docker run -d --restart=always --rm --net=host -l haproxy -v /etc:haproxy:/etc/haproxy vixns/haproxy

and the consul-template config snippset :

	template {
  		source = "/etc/consul-template/templates.d/haproxy.tmpl"
  		destination = "/etc/haproxy/haproxy.cfg"
  		command = "for c in $(docker ps -q --filter='label=haproxy' | awk '{print $NF}');do docker kill -s HUP $c;done || true"
	}

See [consul-template](https://github.com/hashicorp/consul-template) documentation for template syntax.
