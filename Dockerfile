FROM alpine:edge
MAINTAINER wsielski@eaby.com

ENV CONSUL_VERSION 0.7.5
ENV NOMAD_VERSION 0.5.4
ENV FABIO_VERSION 1.3.8

# Compile and install nomad, consul and fabio.
#
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
  apk update; apk upgrade && \
  apk add curl make git go gcc musl-dev openssl-dev && \
  mkdir /go && \
  cd /go && \
  ln -s . src && \
  export GOPATH=/go && \
  go get github.com/Masterminds/glide && \
  cp /go/bin/* /usr/local/bin && \
  glide create --skip-import  --non-interactive  && \
  glide get github.com/eBay/fabio#v${FABIO_VERSION} && \
  glide get github.com/hashicorp/nomad#v${NOMAD_VERSION} && \
  glide get github.com/hashicorp/consul#v${CONSUL_VERSION} && \
  glide update --all-dependencies && \
  go build vendor/github.com/hashicorp/consul && \
  go build vendor/github.com/eBay/fabio && \
  go build vendor/github.com/hashicorp/nomad && \
  mv consul fabio nomad /usr/local/bin && \
  rm -rf /go && \
  apk del make git go gcc musl-dev openssl-dev && \
  rm -rf /var/cache/apk/* && \
  rm -rf /root/.glide && \
  rm /usr/local/bin/glide

# Install tmux and example for demo
#
RUN apk update; apk add tmux && \
  rm -rf /var/cache/apk/* && \
  ln -s /dev/console /0 && \
  ln -s /dev/tty1 /1
ADD tmux.conf /etc/tmux.conf
ADD example.nomad /
