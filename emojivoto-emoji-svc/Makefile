svc_name := emojivoto-emoji-svc
IMAGE_TAG ?= v12
target_dir := target

all: clean protoc test package
.PHONY: package protoc test

clean:
	rm -rf gen
	rm -rf $(target_dir)
	mkdir -p $(target_dir)
	mkdir -p gen

protoc:
	protoc -I .. proto/*.proto --go_out=plugins=grpc:gen --proto_path=proto

compile:
	GOOS=linux go build -v -o $(target_dir)/$(svc_name) cmd/server.go

test:
	go test ./...

run:
	go run cmd/server.go

package: protoc compile build-container

build-container:
	docker build .. -t "asia-docker.pkg.dev/my-kubernetes-cluster-224712/asia.gcr.io/$(svc_name):$(IMAGE_TAG)" --build-arg svc_name=$(svc_name)