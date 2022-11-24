-include env_make

PLATFORM ?= linux/amd64

TAG ?= latest

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

REPO = wodby/squid
NAME = squid

.PHONY: build buildx-build buildx-push buildx-build-amd64 test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) ./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
		--load \
	    ./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) ./

buildx-push:
	docker buildx build --push --platform $(PLATFORM) -t $(REPO):$(TAG) ./

test:
	echo "no tests yet :("

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) -e $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
