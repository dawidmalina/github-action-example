# Github Actions - Example Repository

Project structure:
```
.
├── README.md
├── docker
│   ├── haproxy
│   │   ├── 10-configure-backends.sh
│   │   ├── 20-configure-tls.sh
│   │   ├── 99-print-haproxy-config.sh
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   └── haproxy.cfg
│   └── nginx
│       ├── 99-configure-app.sh
│       ├── Dockerfile
│       └── index.html
├── docker-compose.yaml
```
 
This project will help you to set up an HAProxy as Load balancer with SSL termination 
with two (or more) Nginx backend acting as a simple web app (serving test html page).

The general traffic flow will look like the following:
```
Client ──> HAProxy ──> Nginx
```

## CI process

Docker images used with this project will be automatically build by GitHub Actions and
then pushed to Docker Hub. Each build will update tag version with build number suffix.

[main.yml](.github/workflows/main.yml)
```
name: Build and publish docker images
on:
  # run it on push to the default repository branch
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    # https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs
    strategy:
      fail-fast: false
      matrix:
        include:
          - path: ./docker/haproxy
            image: gh-actions-haproxy:3.17-b${{ github.run_number  }}
          - path: ./docker/nginx
            image: gh-actions-nginx:1.23.2-b${{ github.run_number  }}
    # steps to perform in job
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Build and push
        uses: docker/build-push-action@v3
        with:
          context: ${{ matrix.path }}
          file: ${{ matrix.path }}/Dockerfile
          push: true
          tags: ${{ secrets.DOCKER_HUB_USERNAME }}/${{ matrix.image }}

```


## Testing with docker compose

[docker-compose.yaml](docker-compose.yaml)
```
version: "3.9"

services:
  web:
    image: dawidmalina/gh-actions-haproxy:3.17-b10
    expose:
      - 80
      - 443
    ports:
      - 80:80
      - 443:443
    volumes:
      - type: bind
        source: ./docker/haproxy/default.pem
        target: /etc/ssl/certs/default.pem
        read_only: true
    environment:
      PRINT_CONFIG: true
      BACKEND_1: 172.16.238.11:80
      BACKEND_2: 172.16.238.12:80
      BACKEND_3: 172.16.238.13:80
      CERTIFICATE: /etc/ssl/certs/default.pem
    networks:
      internal:
        ipv4_address: 172.16.238.100

  backend_1:
    image: dawidmalina/gh-actions-nginx:1.23.2-b11
    expose:
      - 80
    environment:
      ADD_CUSTOM_MESSAGE: Nice one
    networks:
      internal:
        ipv4_address: 172.16.238.11

  backend_2:
    image: dawidmalina/gh-actions-nginx:1.23.2-b11
    expose:
      - 80
    environment:
      ADD_CUSTOM_MESSAGE: Nice two
    networks:
      internal:
        ipv4_address: 172.16.238.12

  backend_3:
    image: dawidmalina/gh-actions-nginx:1.23.2-b11
    expose:
      - 80
    environment:
      ADD_CUSTOM_MESSAGE: Nice three
    networks:
      internal:
        ipv4_address: 172.16.238.13

networks:
  internal:
    ipam:
      driver: default
      config:
        - subnet: "172.16.238.0/24"
```

Generate the certificate

> This certificate will be valid only with localhost

```
openssl req -newkey rsa:2048 -nodes -x509 -days 365 -keyout haproxy.key -out haproxy.crt -subj "/CN=127.0.0.1"
cat haproxy.crt haproxy.key >> ./docker/haproxy/default.pem
```

Start the containers

```
docker compose up -d
```

Open this link [http://127.0.0.1](http://127.0.0.1) in your browser (you should redirect you to https) and you should see output from one of the backend.

> You need to add exception as your browser will complain about self-signed certificate

Stop and remove the containers

```
docker compose down 
```
