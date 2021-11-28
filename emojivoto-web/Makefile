IMAGE_TAG ?= v12
svc_name := emojivoto-web
target_dir := target

all: clean protoc webpack package-web test package
.PHONY: package protoc test

clean:
	rm -rf gen
	rm -rf $(target_dir)
	mkdir -p $(target_dir)
	mkdir -p gen

protoc:
	protoc -I .. proto/*.proto --go_out=plugins=grpc:gen --proto_path=proto

webpack:
	$(MAKE) -C webapp

package-web: webpack
	mkdir -p $(target_dir)/web
	cp web/favicon.ico $(target_dir)/web
	cp -a webapp/dist $(target_dir)

test:
	go test ./...

package: protoc compile build-container

compile:
	GOOS=linux go build -v -o $(target_dir)/$(svc_name) cmd/server.go

run:
	go run cmd/server.go

build-container:
	docker build .. -t "asia-docker.pkg.dev/my-kubernetes-cluster-224712/asia.gcr.io/$(svc_name):$(IMAGE_TAG)" --build-arg svc_name=$(svc_name)
