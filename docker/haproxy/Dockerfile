# Pull the minimal oficial nginx image based on alpine
FROM haproxy:lts-alpine3.17

# Add information about maintainer
LABEL maintainer="Dawid Malinowski <dawidmalina@gmail.com>"

# Provide custom entrypoint scripts
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./10-configure-backends.sh /docker-entrypoint.d/10-configure-backends.sh
COPY ./20-configure-tls.sh /docker-entrypoint.d/20-configure-tls.sh
COPY 99-print-haproxy-config.sh /docker-entrypoint.d/99-configure-dummy-certificate.sh

# Provide config template
COPY ./haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

# Allow entrypoint scipts to edit config
RUN id
USER root
RUN chown -R haproxy:haproxy /usr/local/etc/haproxy
USER haproxy

# Overwrite default entrypoint and command
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]