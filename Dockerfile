FROM alpine:edge
MAINTAINER wsielski@eaby.com

ENV CONSUL_VERSION 0.8.0
ENV NOMAD_VERSION 0.5.6
ENV FABIO_VERSION 1.4.2

ENV GOLANG_VERSION 1.8.1
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 33daf4c03f86120fdfdc66bddf6bfff4661c7ca11c5da473e537f4d69b470e57

# Compile and install nomad, consul and fabio.
RUN set -ex \
  && echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && apk update; apk upgrade \
  && apk add --no-cache --virtual .build-deps \
    bash \
    go \
    curl \
    make \
    git \
    gcc \
    musl-dev \
    openssl \
    openssl-dev \
  \
  # Compile go \
  \
  && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
  && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
  && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/go/src \
  && ./make.bash \
  \
  && export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
  && mkdir /go \
  && cd /go \
  && ln -s . src \
  && export GOPATH=/go \
  && go get github.com/Masterminds/glide \
  && cp /go/bin/* /usr/local/bin \
  \
  # Compile fabio, nomad, consul \
  \
  && glide create --skip-import  --non-interactive  \
  && glide get github.com/eBay/fabio#v${FABIO_VERSION} \
  && glide get github.com/hashicorp/nomad#v${NOMAD_VERSION} \
  && glide get github.com/hashicorp/consul#v${CONSUL_VERSION} \
  && glide update --all-dependencies \
  && go build vendor/github.com/hashicorp/consul \
  && go build vendor/github.com/eBay/fabio \
  && go build vendor/github.com/hashicorp/nomad \
  && mv consul fabio nomad /usr/local/bin \
  \
  # Cleanup \
  \
  && rm -rf /go \
  && apk del .build-deps \
  && rm -rf /usr/local/go \
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.glide \
  && rm /usr/local/bin/glide

# Install tmux and example for demo
#
RUN apk update; apk add tmux \
  && rm -rf /var/cache/apk/* \
  && ln -s /dev/console /0 \
  && ln -s /dev/tty1 /1
ADD tmux.conf /etc/tmux.conf
ADD example.nomad /
