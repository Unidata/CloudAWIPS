ORG = unidata
IMAGE = cloudawips

all: build push

build:
	docker build \
		-t $(ORG)/$(IMAGE) \
		-f Dockerfile \
		--build-arg IMAGE=$(ORG)/$(IMAGE) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.
push:
	docker push $(ORG)/$(IMAGE)

.PHONY: build push
