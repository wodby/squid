# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.24 := sha256:e4cb7c76b561c5e5dc19a8cf8ff76dd324269ac9d544c88c6bf18fe0d94398fc
BASE_IMAGE_DIGEST_3.24-r12 := sha256:481b17bb65575e8127943abf8895884e0ffc69077fadc6b0d93387b8bc4da1ad

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
