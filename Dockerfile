FROM debian:buster-slim

LABEL \
  maintainer="Tarbase <hello@tarbase.com>" \
  vendor="Tarbase" \
  cmd="docker container run --detach --publish 1194:1194/udp --publish 1194:1194 --publish 443:443 --privileged --device=/dev/net/tun tarbase/pritunl" \
  params="--env MONGODB_URI=mongodb_address"

EXPOSE \
  443 \
  1194 \
  1194/udp

ENV LANG=C.UTF-8

COPY files/ /root/

RUN \
# copy scripts
  install --owner=root --group=root --mode=0755 --target-directory=/usr/bin /root/scripts/* && \
# copy tests
  install --owner=root --group=root --mode=0755 --target-directory=/usr/bin /root/tests/* && \
# dependencies
  apt-get -qq update && \
  dpkg-query --show -f='${Package}\n' > /tmp/dependencies.pre && \
  apt-get -qq -y --no-install-recommends install \
    dirmngr \
    gpg \
    gpg-agent \
    > /dev/null 2>&1 && \
  dpkg-query --show -f='${Package}\n' > /tmp/dependencies.post && \
# repos
  echo 'deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main' \
    > /etc/apt/sources.list.d/mongodb-org-4.2.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com --receive-keys --recv 0x4b7c549a058f8b6b && \
  echo 'deb http://repo.pritunl.com/stable/apt buster main' \
    > /etc/apt/sources.list.d/pritunl.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com --receive-keys --recv 0x7ae645c0cf8e292a && \
  apt-get -qq update && \
# dependencies cleanup
  apt-get -qq -y purge \
    $(diff --changed-group-format='%>' --unchanged-group-format='' /tmp/dependencies.pre /tmp/dependencies.post | xargs) \
    > /dev/null 2>&1 && \
# mongodb
  install --directory --owner=root --group=root --mode=0755 /data/mongodb && \
  apt-get -qq -y --no-install-recommends install \
    mongodb-org-server \
    > /dev/null 2>&1 && \
  sed -i '/systemLog/,/^$/ s/^/##/' /etc/mongod.conf && \
# pritunl
  apt-get -qq -y --no-install-recommends install \
    iptables \
    iputils-ping \
    openssl \
    openvpn \
    pritunl \
    procps \
    > /dev/null 2>&1 && \
  sed -i -e 's/utils.rand_str.*/DEFAULT_PASSWORD/' /usr/lib/pritunl/lib/python2.7/site-packages/pritunl/auth/administrator.py && \
  pritunl set-mongodb 'mongodb://127.0.0.1:27017/pritunl' && \
  find /usr/lib -depth \( \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' + && \
# system settings
  install --directory --owner=root --group=root --mode=0755 /build/run/systemd && \
  echo 'docker' > /build/run/systemd/container && \
# system cleanup
  apt-get clean && \
  rm -rf /usr/share/info/* && \
  rm -rf /usr/share/locale/* && \
  rm -rf /usr/share/man/* && \
  rm -rf /var/cache/apt/* && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/log/* && \
  rm -rf /root/.??* && \
  rm -rf /tmp/.??* && \
  find /usr/share/doc -mindepth 1 -not -name copyright -not -type d -delete && \
  find /usr/share/doc -mindepth 1 -type d -empty -delete && \
  find /var/cache -type f -delete

ENTRYPOINT ["/usr/bin/entrypoint"]
