FROM golang:1.13.2-alpine

ENV PACKAGES="build-base autoconf automake libtool"
RUN apk update && apk upgrade && \
	apk add --update git bash ssh curl libstdc++ && \
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