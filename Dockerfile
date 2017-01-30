FROM ubuntu:16.04
MAINTAINER tarbase <hello@tarbase.com>

# Install the pritunl repository and public key (CF8E292A)
RUN echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

# Update the package catalog and upgrade any existing packages
RUN apt-get update -q &&\
    apt-get upgrade -y -q

# Install the pritunl package
RUN apt-get -y install pritunl

# Don't forget to cleanup after our ourselves
RUN apt-get clean &&\
    apt-get -y -q autoclean &&\
    apt-get -y -q autoremove &&\
    rm -rf /tmp/*

COPY bin/start-pritunl.sh /usr/bin/start-pritunl.sh

EXPOSE 1194
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/usr/bin/start-pritunl.sh"]

CMD ["/usr/bin/tail", "-f", "/var/log/pritunl.log"]
