ORG = unidata
IMAGE = cloudawips
TAG = latest

all: build push

build:
	docker build  \
		-t $(ORG)/$(IMAGE):$(TAG) \
		-f Dockerfile \
		--build-arg IMAGE=$(ORG)/$(IMAGE):$(TAG) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.
push:
	docker push $(ORG)/$(IMAGE):$(TAG)

.PHONY: build push
