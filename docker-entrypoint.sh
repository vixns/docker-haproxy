#!/bin/sh
set -e

#env  | sed -e 's/=/="/' | sed -e 's/$/"/'^C > /etc/envvars
for K in $(env | cut -d= -f1)
do
    VAL=$(eval echo \$$K)
    echo "${K}=\"${VAL}\"" >> /etc/envvars
done
mkdir -p /etc/service/haproxy
shift
cat > /etc/service/haproxy/run << EOF
#!/bin/sh
exec $(which haproxy-systemd-wrapper) -p /run/haproxy.pid $@
EOF
chmod +x /etc/service/haproxy/run
exec /sbin/tini -- /sbin/runsvdir -P /etc/service