# Pull the minimal oficial nginx image based on alpine
FROM haproxy:lts-alpine3.17

# Add information about maintainer
LABEL maintainer="Dawid Malinowski <dawidmalina@gmail.com>"

# Create directory for custom init scripts
RUN mkdir /docker-entrypoint.d

# Provide custom entrypoint script
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

# Overwrite default entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]