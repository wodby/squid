#!/usr/bin/env bash

set -euo pipefail

if [[ "${GITHUB_REF}" == refs/heads/main || "${GITHUB_REF}" == refs/tags/* ]]; then
    printf '%s' "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

    if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
      export IMAGE_REVISION="${GITHUB_REF##*/}"
    fi

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        # Retag the scanned image instead of rebuilding it for each alias.
        image=$(make --no-print-directory -s image-ref TAG="${tag}")
        docker tag "${SCANNED_IMAGE:?Missing scanned image}" "$image"
        make push TAG="${tag}"
    done
fi
