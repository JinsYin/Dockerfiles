FROM alpine:3.5

RUN set -ex \
    && apk add --no-cache ca-certificates apache2-utils

ENV STORAGE_SWIFT_AUTHURL=""
ENV STORAGE_SWIFT_USERNAME=""
ENV STORAGE_SWIFT_PASSWORD=""
ENV HTTP_PORT="5000"

COPY ./registry/registry /bin/registry
COPY ./registry/config-local.yml /etc/docker/registry/config-local.yml
COPY ./registry/config-ceph.yml /etc/docker/registry/config-ceph.yml
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]