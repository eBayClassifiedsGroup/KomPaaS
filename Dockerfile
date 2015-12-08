FROM alpine:edge
MAINTAINER wsielski@eaby.com

ENV CONSUL_VERSION v0.6.0
ENV NOMAD_VERSION v0.2.1
ENV FABIO_VERSION v1.0.6

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
  apk update; apk upgrade && \
  apk add curl make git go gcc musl-dev openssl-dev && \
  mkdir /go && \
  export GOPATH=/go && \
  go get -u -tags ${CONSUL_VERSION} github.com/hashicorp/consul && \
  go get -u -tags ${NOMAD_VERSION}  github.com/hashicorp/nomad && \
  go get -u -tags ${FABIO_VERSION}  github.com/eBay/fabio && \
  mv /go/bin/* /usr/local/bin && \
  rm -rf /go && \
  apk del make git go gcc musl-dev openssl-dev && \
  rm -rf /var/cache/apk/*

RUN curl -L https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip -o ui.zip && \
  unzip ui.zip && \
  rm /ui.zip

RUN apk update; apk add tmux screen && \
  rm -rf /var/cache/apk/*
ADD tmux.conf /etc/tmux.conf
RUN ln -s /dev/tty1 /1
ADD example.nomad /
