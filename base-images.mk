# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.24 := sha256:48e9bd7448c6ae439a2a116f6debee6824a1e120b26080b7d3fe7a9ab716894a
BASE_IMAGE_DIGEST_3.24-r14 := sha256:b14ace0c6c448e777b7196885f186f0ef3f2c4e5f92d2389290a23285c69e4d1

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
