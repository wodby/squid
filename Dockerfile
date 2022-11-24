FROM alpine:3.17

RUN set -ex; \
    apk add --update squid ca-certificates tzdata bash; \
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