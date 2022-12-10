#!/bin/sh
set -e

ARGS="$@"

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

# Inspired by nginx official image: https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/docker-entrypoint.sh
entrypoint_log() {
    if [ -z "${HAPROXY_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    entrypoint_log "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

    entrypoint_log "$0: Looking for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.envsh)
                if [ -x "$f" ]; then
                    entrypoint_log "$0: Sourcing $f";
                    . "$f"
                else
                    # warn on shell scripts without exec bit
                    entrypoint_log "$0: Ignoring $f, not executable";
                fi
                ;;
            *.sh)
                if [ -x "$f" ]; then
                    entrypoint_log "$0: Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    entrypoint_log "$0: Ignoring $f, not executable";
                fi
                ;;
            *) entrypoint_log "$0: Ignoring $f";;
        esac
    done

    entrypoint_log "$0: Configuration complete; ready for start up"
else
    entrypoint_log "$0: No files found in /docker-entrypoint.d/, skipping configuration"
fi

entrypoint_log "$0: ${ARGS}"

exec "$@"