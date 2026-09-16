#!/usr/bin/env sh
set -eu
: "${IMAGE:?IMAGE is required}"
docker run --rm --entrypoint sh "$IMAGE" -ec '
  squid -v | grep -F "Version 7."
  squid -k parse
  test -s /etc/ssl/certs/ca-certificates.crt
'
