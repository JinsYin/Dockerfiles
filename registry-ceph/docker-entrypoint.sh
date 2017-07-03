#!/bin/sh

set -e

if [ -n "$STORAGE_SWIFT_AUTHURL" ] && [ -n "$STORAGE_SWIFT_USERNAME" ] && [ -n "$STORAGE_SWIFT_PASSWORD" ]; then
	sed -e "s|\$STORAGE_SWIFT_AUTHURL|$STORAGE_SWIFT_AUTHURL|g" \
		-e "s|\$STORAGE_SWIFT_USERNAME|$STORAGE_SWIFT_USERNAME|g" \
		-e "s|\$STORAGE_SWIFT_PASSWORD|$STORAGE_SWIFT_PASSWORD|g" \
		-e "s|\$HTTP_PORT|$HTTP_PORT|g" \
		/etc/docker/registry/config-ceph.yml > /etc/docker/registry/config.yml
else
	sed -e "s|\$HTTP_PORT|$HTTP_PORT|g" /etc/docker/registry/config-local.yml > /etc/docker/registry/config.yml
fi

case "$1" in
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"