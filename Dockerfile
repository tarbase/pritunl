FROM alpine:3.5
MAINTAINER tarbase <hello@tarbase.com>

ENV VERSION="1.26.1231.99"

RUN apk --no-cache add --update go git bzr wget py2-pip \
    gcc python python-dev musl-dev linux-headers libffi-dev openssl-dev \
    py-setuptools openssl procps ca-certificates openvpn

RUN export GOPATH=/go \
    && go get github.com/pritunl/pritunl-dns \
    && go get github.com/pritunl/pritunl-monitor \
    && go get github.com/pritunl/pritunl-web \
    && cp /go/bin/* /usr/bin/

RUN wget https://github.com/pritunl/pritunl/archive/${VERSION}.tar.gz \
    && tar zxvf ${VERSION}.tar.gz \
    && cd pritunl-${VERSION} \
    && python setup.py build \
    && pip install -r requirements.txt \
    && python2 setup.py install \
    && cd .. \
    && rm -rf *${VERSION}* \
    && rm -rf /tmp/* /var/cache/apk/* \
    && rm -rf /go

RUN apk del go git bzr wget gcc python-dev musl-dev linux-headers libffi-dev openssl-dev

ADD bin/start-pritunl.sh /usr/bin/start-pritunl.sh

EXPOSE 1194
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/usr/bin/start-pritunl.sh"]

CMD ["/usr/bin/tail", "-f", "/var/log/pritunl.log"]
