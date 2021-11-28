include ./common.mk

.PHONY: web emoji-svc voting-svc push

all: build

build: web emoji-svc voting-svc

web:
	$(MAKE) -C emojivoto-web

emoji-svc:
	$(MAKE) -C emojivoto-emoji-svc

voting-svc:
	$(MAKE) -C emojivoto-voting-svc

multi-arch:
	$(MAKE) -C emojivoto-web build-multi-arch
	$(MAKE) -C emojivote-emoji-svc build-multi-arch
	$(MAKE) -C emojivote-voting-svc build-multi-arch

build-base-docker-image:
	docker build . -f Dockerfile-base -t "asia-docker.pkg.dev/my-kubernetes-cluster-224712/asia.gcr.io/emojivoto-svc-base:$(IMAGE_TAG)"

push-%:
	docker push asia-docker.pkg.dev/my-kubernetes-cluster-224712/asia.gcr.io/emojivoto-$*:$(IMAGE_TAG)

push: push-svc-base push-emoji-svc push-voting-svc push-web
