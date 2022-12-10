#!/bin/sh

set -eu

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${HAPROXY_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo -e "$@"
    fi
}

if [ -n "${CERTIFICATE:-}" ]; then
    entrypoint_log "$ME: info: exposing haproxy with provided certificate (${CERTIFICATE}) on port 443"
    sed -i -e 's,<--CERTIFICATE-->,\n    bind :443 ssl crt '"${CERTIFICATE}"'\n    http-request redirect scheme https unless { ssl_fc },'  /usr/local/etc/haproxy/haproxy.cfg
else
    entrypoint_log "$ME: info: skipping tls configuration"
    sed -i -e "s/<--CERTIFICATE-->//g" /usr/local/etc/haproxy/haproxy.cfg
fi
