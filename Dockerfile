FROM golang:1.13.2-alpine

ENV PACKAGES="build-base autoconf automake libtool"
RUN addgroup -g 993 gitlab-runner && \
    adduser -u 996 -G gitlab-runner -s /bin/sh -D gitlab-runner

RUN apk update && apk upgrade && \
	apk add --update git bash openssh curl libstdc++ && \
	apk add --update $PACKAGES && \
	git clone https://github.com/google/protobuf.git && \
    cd protobuf && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig /etc/ld.so.conf.d && \
    make clean && \
    cd .. && \
    rm -r protobuf && \
	go get -u github.com/golang/protobuf/proto && \
	go get -u github.com/golang/protobuf/protoc-gen-go && \
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
	apk del $PACKAGES && \
	rm -rf /var/cache/apk/*

USER gitlab-runner