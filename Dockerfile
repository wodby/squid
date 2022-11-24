ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

ARG SQUID_VER

ENV SQUID_VER="${SQUID_VER}"

RUN set -ex; \
    apk add --update  --no-cache -t squid-rundeps \
      "squid~${SQUID_VER}"  \
      ca-certificates  \
      tzdata  \
      bash; \
    \
    mkdir -p /etc/squid/conf.d/; \
    echo "# Set max_filedescriptors to avoid using system's RLIMIT_NOFILE. See LP: #1978272" > /etc/squid/conf.d/rock.conf; \
    echo 'max_filedescriptors 1024' >> /etc/squid/conf.d/rock.conf; \
    \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["entrypoint.sh"]

VOLUME ['/var/log/squid', '/var/spool/squid']

EXPOSE 3128

CMD ["-f", "/etc/squid/squid.conf", "-NYC"]