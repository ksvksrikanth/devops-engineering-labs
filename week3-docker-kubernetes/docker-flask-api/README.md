# Local Setup

## Prerequisites

- Docker Desktop installed and running
- Terminal opened in this folder:

```powershell
cd D:\DevOps-Learning\week3-docker-kubernetes\docker-flask-api
```

## Build the Docker Image

```powershell
docker build -t flask-api:1.0 .
```

## Run the Container

```powershell
docker run -d --name flask-api -p 5000:5000 flask-api:1.0
```

## Verify the API

Open the API in a browser or test it from the terminal:

```powershell
curl http://localhost:5000/
curl http://localhost:5000/health
```

The health endpoint should return:

```json
{"status":"healthy"}
```

## View Container Logs

```powershell
docker logs flask-api
```

## Stop and Remove the Container

```powershell
docker stop flask-api
docker rm flask-api
```
