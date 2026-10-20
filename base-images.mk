# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.24 := sha256:cb0b3f1a36a9d9e02c739d8c36bc298a1d64eea39aa725559b46b42630b2801f
BASE_IMAGE_DIGEST_3.24-r5 := sha256:5d3d9d346f7ba94eccd66cc69598f6ee0a674e816c3af07418285b917eaed6fd

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
