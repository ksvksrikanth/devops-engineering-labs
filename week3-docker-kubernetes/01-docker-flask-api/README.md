# Local Setup

## Prerequisites

- Docker Desktop installed and running
- Terminal opened in this folder:

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\01-docker-flask-api
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

## GitHub Actions Workflows

This Flask API project has two GitHub Actions workflows in the repository `.github/workflows` directory.

### `flask-api-docker-build.yml`

Purpose: validates that the Docker image can be built successfully and that the Flask API starts correctly.

This workflow runs manually from the GitHub Actions tab using `workflow_dispatch`.

It performs these steps:

- Checks out the repository code
- Sets up Docker Buildx
- Builds the Docker image from `week3-docker-kubernetes/01-docker-flask-api`
- Runs the container locally in GitHub Actions
- Calls `http://localhost:5000/health` as a smoke test
- Prints container logs
- Stops and removes the test container

### `flask-api-docker-build-aws.yml`

Purpose: builds the Flask API Docker image and pushes it to Amazon ECR.

This workflow runs manually from the GitHub Actions tab using `workflow_dispatch`.

It performs these steps:

- Checks out the repository code
- Authenticates to AWS using GitHub OIDC
- Assumes the AWS IAM role `GitHubActionsDeployRole`
- Logs in to Amazon ECR
- Builds the Docker image from `week3-docker-kubernetes/01-docker-flask-api`
- Tags the image with the Git commit SHA
- Tags the image as `latest`
- Pushes both tags to the `docker-flask-api` ECR repository in `ap-south-1`
