# devrouter

Caddy + Docker powered reverse proxy for your local apps

## Prerequisites

Docker and Docker Compose needs to be installed.

## Installing

```
git clone https://github.com/sperrichon/devrouter.git
cd devrouter
cp .env.dist .env
```

## Usage

```
vi .env
docker-compose up --build
```

**Note**: Configuration is rebuilt in the container, and effective just after sites or title are edited