-include env.mk

# Accept legacy build arguments during the image revision transition.
BASE_IMAGE_REVISION ?= $(BASE_IMAGE_STABILITY_TAG)
IMAGE_REVISION ?= $(STABILITY_TAG)

SQUID_VER ?= 7.6

TAG ?= $(SQUID_VER)

ALPINE_VER ?= 3.24

ifeq ($(BASE_IMAGE_REVISION),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_REVISION)
endif

REPO = wodby/squid
NAME = squid-$(SQUID_VER)

ifneq ($(IMAGE_REVISION),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(IMAGE_REVISION)
    else ifneq ($(filter r%,$(IMAGE_REVISION)),)
        override TAG := $(IMAGE_REVISION)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

# Resolve the same pinned base image for every local and CI build target.
include base-images.mk

default: build

build:
	docker build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --pull -t $(REPO):$(TAG) \
		--build-arg SQUID_VER=$(SQUID_VER) ./

test:
	IMAGE=$(REPO):$(TAG) ./tests/run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(LINKS) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push

# Keep CI scans aligned with the version, variant and architecture built by make.
.PHONY: image-ref
image-ref:
	@printf '%s\n' '$(REPO):$(TAG)'
