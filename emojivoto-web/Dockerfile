# go build stage
FROM golang:1.15.0 as golang
WORKDIR /emojivoto-build

# install protobuf
RUN apt-get update && apt-get install -y protobuf-compiler
RUN go get github.com/golang/protobuf/protoc-gen-go

# cache go dependencies
COPY go.mod .
COPY go.sum .
RUN go mod download

# compile
COPY . .
ARG TARGETARCH
RUN GOARCH=$TARGETARCH make clean protoc compile

# webpack stage
FROM node:14-buster as webpack-bundle
WORKDIR /emojivoto-build
COPY . .
RUN make clean webpack package-web

FROM golang as build-emojivoto-web
COPY --from=webpack-bundle /emojivoto-build/target/ /emojivoto-build/target/

FROM build-emojivoto-web as build

# runtime image
FROM debian:buster-20200514-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        dnsutils \
        iptables \
        jq \
        nghttp2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /emojivoto-build/target/ /usr/local/bin/

# ARG variables are not available for ENTRYPOINT
ENV SVC_NAME emojivoto-web
WORKDIR /usr/local/bin
ENTRYPOINT $SVC_NAME
