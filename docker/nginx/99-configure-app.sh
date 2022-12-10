#!/bin/sh

set -eu

DEFAULT_MESSAGE="Hello from app container"

# configure text message exposed by the application
if [ -n "${ADD_CUSTOM_MESSAGE}" ]; then
    entrypoint_log "$ME: info: using custom text message"
    sed -i -e "s/<--MESSAGE-->/${ADD_CUSTOM_MESSAGE}/g"
else
    entrypoint_log "$ME: info: using default text message"
    sed -i -e "s/<--MESSAGE-->/${DEFAULT_MESSAGE}/g"
fi