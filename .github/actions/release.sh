#!/usr/bin/env bash

# Version aliases identify published releases; only primary tags publish images.
if [[ "${GITHUB_REF:-}" =~ ^refs/tags/.+-r[0-9]+$ ]]; then
    exit 0
fi

set -euo pipefail

if [[ "${GITHUB_REF}" == refs/heads/main || "${GITHUB_REF}" == refs/tags/* ]]; then
    printf '%s' "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

    if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
      export IMAGE_REVISION="${GITHUB_REF##*/}"
    fi

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        # Squid uses a two-part full version. Publish its local revision alias
        # after the build, without occupying that name with the primary counter.
        if [[ "${IMAGE_REVISION:-}" =~ ^r(0|[1-9][0-9]*)$ && "${tag}" == "${SQUID_VER}" ]]; then
            continue
        fi
        # Retag the scanned image instead of rebuilding it for each alias.
        image=$(make --no-print-directory -s image-ref TAG="${tag}")
        docker tag "${SCANNED_IMAGE:?Missing scanned image}" "$image"
        make push TAG="${tag}"
    done
fi
