#!/usr/bin/env sh
set -eu
: "${IMAGE:?IMAGE is required}"
docker run --rm --entrypoint sh "$IMAGE" -ec '
  squid -v | grep -F "Version 7."
  squid -k parse
  test -s /etc/ssl/certs/ca-certificates.crt

  # Use a local origin so the proxy check does not depend on an external site.
  printf "HTTP/1.1 200 OK\r\nContent-Length: 15\r\nConnection: close\r\n\r\nsquid-proxy-ok\n" |
    nc -l -p 18080 >/dev/null &
  entrypoint.sh -f /etc/squid/squid.conf -NYC >/tmp/squid-test.log 2>&1 &
  for attempt in $(seq 1 20); do
    if curl --max-time 3 --fail --silent --noproxy "" -D /tmp/proxy-headers \
      --proxy http://127.0.0.1:3128 http://127.0.0.1:18080/ |
      grep -qx squid-proxy-ok; then
      grep -F "(squid/7." /tmp/proxy-headers
      exit 0
    fi
    sleep 1
  done
  cat /tmp/squid-test.log
  exit 1
'
