.PHONY: web emoji-svc voting-svc push

all: build
build: web emoji-svc voting-svc
push: push-svc-base push-emoji-svc push-voting-svc push-web

web:
	$(MAKE) -C emojivoto-web

emoji-svc:
	$(MAKE) -C emojivoto-emoji-svc

voting-svc:
	$(MAKE) -C emojivoto-voting-svc

push-%:
	docker push asia-docker.pkg.dev/my-kubernetes-cluster-224712/asia.gcr.io/emojivoto-$*:$(IMAGE_TAG)