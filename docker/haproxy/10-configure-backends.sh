#!/bin/sh

set -eu

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${HAPROXY_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

BACKENDS=$( env | grep BACKEND_ | sort | awk 'match($0, /BACKEND_[0-9]+/) { print substr( $0, RSTART, RLENGTH )}' | uniq )

if [ -n "${BACKENDS}" ]; then
    for BACKEND in ${BACKENDS}
    do
        CONF=$( env |grep "${BACKEND}" |sed 's/^[^=]*=//' )
        entrypoint_log "$ME: info: adding backend ${BACKEND} (${CONF}) to haproxy configuration"
        echo "    server ${BACKEND} ${CONF}" >> /usr/local/etc/haproxy/haproxy.cfg
    done
    echo "" >> /usr/local/etc/haproxy/haproxy.cfg
else
    entrypoint_log "$ME: error: missing backend configuration"
    exit 1
fi
