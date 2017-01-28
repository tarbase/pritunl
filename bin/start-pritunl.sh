#!/usr/bin/env bash

set -e

touch /var/log/pritunl.log

if [ -z "$MONGODB_URI" ]; then
  MONGODB_URI="mongodb://mongo:27017/pritunl"
fi

echo "Connecting to MongoDB in $MONGODB_URI"

cat << EOF > /etc/pritunl.conf
{
    "mongodb_uri": "$MONGODB_URI",
    "server_key_path": "/var/lib/pritunl/pritunl.key",
    "log_path": "/var/log/pritunl.log",
    "static_cache": true,
    "server_cert_path": "/var/lib/pritunl/pritunl.crt",
    "temp_path": "/tmp/pritunl_%r",
    "bind_addr": "0.0.0.0",
    "debug": false,
    "www_path": "/usr/share/pritunl/www",
    "local_address_interface": "auto",
    "port": 443
}
EOF

/usr/bin/pritunl start &
[ "$1" ] && exec "$@"
