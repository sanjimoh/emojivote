# go build stage
FROM golang:1.15.0 as golang
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
RUN GOARCH=$TARGETARCH make -C emojivoto-emoji-svc clean protoc compile

FROM build-emojivoto-emoji-svc as build

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

COPY --from=build /emojivoto-build/emojivoto-emoji-svc/target/ /usr/local/bin/

# ARG variables are not available for ENTRYPOINT
ENV SVC_NAME emojivoto-emoji-svc
WORKDIR /usr/local/bin
ENTRYPOINT $SVC_NAME
