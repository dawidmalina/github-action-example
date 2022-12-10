#!/bin/sh

set -eu

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${HAPROXY_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo -e "$@"
    fi
}

# should we pring config
if [ "${PRINT_CONFIG:-false}" == "true" ]; then
    entrypoint_log "$ME: info: \n$( cat /usr/local/etc/haproxy/haproxy.cfg )"
fi

