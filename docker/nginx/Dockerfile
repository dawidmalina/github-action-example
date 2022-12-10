# Pull the minimal oficial nginx image based on alpine
FROM nginx:1.23.2-alpine

# Add information about maintainer
LABEL maintainer="Dawid Malinowski <dawidmalina@gmail.com>"

# Copy test html page
COPY ./index.html /usr/share/nginx/html/index.html

# Copy custom configuration script
COPY ./99-configure-app.sh /docker-entrypoint.d/99-configure-app.sh