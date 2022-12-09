# Github Actions - Example Repository

Project structure:
```
├── README.md
├── docker
│  ├── haproxy
│  │   └── Dockerfile
│  └── nginx
│      └── Dockerfile
└── docker-compose.yaml
```

This project will help you to set up an HAProxy as Load balancer with SSL termination 
with two (or more) Nginx backend acting as a simple web app (serving test html page).

The general traffic flow will look like the following:
```
Client ──> HAProxy ──> Nginx
```

## CI process

Docker images used with this project will be automatically build by GitHub Actions and
then pushed to Docker Hub.

plik
```
```


## Testing with docker compose

Starting the containers

```
docker compose up -d
```

Stop and remove the containers

```
docker compose down 
```