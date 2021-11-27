# go build stage
FROM --platform=$BUILDPLATFORM golang:1.15.0 as golang
WORKDIR /emojivoto-build

# install protobuf
RUN apt-get update && apt-get install -y protobuf-compiler
RUN go get github.com/golang/protobuf/protoc-gen-go

# cache go dependencies
COPY go.mod go.sum .
RUN go mod download

# compile
COPY . .
ARG TARGETARCH
RUN GOARCH=$TARGETARCH make -C emojivoto-web clean protoc compile

# webpack stage
FROM --platform=$BUILDPLATFORM node:14-buster as webpack-bundle
WORKDIR /emojivoto-build
COPY . .
RUN make -C emojivoto-web clean webpack package-web

FROM golang as build-emojivoto-web
COPY --from=webpack-bundle /emojivoto-build/emojivoto-web/target/ /emojivoto-build/emojivoto-web/target/

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

COPY --from=build /emojivoto-build/emojivoto-web/target/ /usr/local/bin/

# ARG variables are not available for ENTRYPOINT
ENV SVC_NAME emojivoto-web
WORKDIR /usr/local/bin
ENTRYPOINT $SVC_NAME
