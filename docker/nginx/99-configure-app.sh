#!/bin/sh

set -eu

DEFAULT_MESSAGE="Hello from app container"

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

# configure text message exposed by the application
if [ -n "${ADD_CUSTOM_MESSAGE:-}" ]; then
    entrypoint_log "$ME: info: using custom text message: ${ADD_CUSTOM_MESSAGE}"
    sed -i -e "s/<--MESSAGE-->/${ADD_CUSTOM_MESSAGE}/g" /usr/share/nginx/html/index.html
else
    entrypoint_log "$ME: info: using default text message: ${DEFAULT_MESSAGE}"
    sed -i -e "s/<--MESSAGE-->/${DEFAULT_MESSAGE}/g" /usr/share/nginx/html/index.html
fi