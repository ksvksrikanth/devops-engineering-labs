# Week 3: Docker and Containerized Applications

This folder is a hands-on learning portfolio that progresses from basic Dockerfile syntax to multi-container application design, persistent storage, production-oriented images, CI smoke testing, and AWS ECR delivery.

## Skills Demonstrated

- Building images with Dockerfiles
- Running and inspecting containers
- Publishing container ports
- Configuring applications with environment variables
- Persisting data with named volumes and bind mounts
- Connecting services through Docker Compose networks
- Initializing and querying MySQL from PHP and Flask applications
- Serving static content with Nginx
- Building smaller multi-stage Python images
- Running a Flask API with Gunicorn as a non-root user
- Adding container health checks and restart policies
- Building and smoke-testing images with GitHub Actions
- Authenticating to AWS through GitHub OIDC
- Tagging and pushing Docker images to Amazon ECR

## Portfolio Structure

```text
week3-docker-kubernetes/
|-- 00-DockerFiles/
|-- 01-docker-flask-api/
|-- 02-docker-php-mysql/
|-- 03-docker-volume-notes/
|-- 04-simple-webapp/
|-- 05-python-env-api/
|-- 06-docker-static-site/
|-- 07-docker-multistage-flask/
|-- 08-docker-prod-compose/
`-- README.md
```

## Projects

### 00 - Dockerfile Fundamentals

Location: `00-DockerFiles/PythonDockerfile`

A reference Python Dockerfile demonstrating the core image build sequence: select a base image, set a working directory, install dependencies, copy application code, and define the startup command.

Learning focus:

- `FROM`, `WORKDIR`, `COPY`, `RUN`, and `CMD`
- Docker layer ordering
- Python dependency installation inside an image

This is a reference template rather than a standalone runnable project because its application and requirements files are not stored in the same folder.

### 01 - Docker Flask API

Location: `01-docker-flask-api`

A containerized Flask JSON API with root and health endpoints. Its response exposes the configured environment and container hostname, making the difference between local and container execution visible.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\01-docker-flask-api
docker build -t flask-api:1.0 .
docker run -d --name flask-api -p 5000:5000 flask-api:1.0
curl http://localhost:5000/
curl http://localhost:5000/health
```

Learning focus:

- Python slim base images
- Dependency caching through ordered `COPY` instructions
- Container environment variables
- Health endpoints and CI smoke tests
- ECR image tagging and delivery

See `01-docker-flask-api/README.md` for detailed setup and workflow notes.

### 02 - PHP and MySQL with Docker Compose

Location: `02-docker-php-mysql`

A two-service Compose application where Apache/PHP connects to MySQL using the Compose service name `db`. MySQL initializes a table and sample record from `mysql/init.sql`, while a named volume persists database data.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\02-docker-php-mysql
docker compose up --build -d
curl http://localhost:8080
docker compose down
```

Learning focus:

- Multi-container orchestration
- Compose DNS and service discovery
- MySQL initialization scripts
- Named volumes
- Building a PHP image with the `mysqli` extension

### 03 - Persistent Notes API

Location: `03-docker-volume-notes`

A Flask notes API that writes records to `/data/notes.txt`. A Docker volume keeps the notes available when the application container is removed and recreated.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\03-docker-volume-notes
docker build -t docker-volume-notes .
docker volume create notes-data
docker run -d --name notes-api -p 5000:5000 -v notes-data:/data docker-volume-notes
curl http://localhost:5000/notes
```

Example note creation:

```powershell
curl -Method Post -Uri http://localhost:5000/notes -ContentType "application/json" -Body '{"note":"persistent Docker note"}'
```

Learning focus:

- Named volumes and persistent state
- Configurable data paths
- GET and POST API behavior
- Container recreation without data loss

### 04 - Simple Flask Web Application

Location: `04-simple-webapp`

A basic Flask website built from an Ubuntu base image. It installs Flask through the operating-system package manager and starts the application through the Flask CLI.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\04-simple-webapp
docker build -t simple-webapp .
docker run --rm -p 5000:5000 simple-webapp
```

Learning focus:

- Building on a general-purpose Linux base image
- Installing runtime packages with `apt-get`
- `ENTRYPOINT` behavior
- Comparing general and language-specific base images

### 05 - Environment-configured Python API

Location: `05-python-env-api`

A Flask API whose application name and environment are supplied at runtime rather than baked into the image.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\05-python-env-api
docker build -t python-env-api .
docker run --rm -p 5000:5000 -e APP_NAME="Learning API" -e APP_ENV="test" python-env-api
```

Learning focus:

- Runtime configuration with `-e`
- Reusing one image across environments
- Sensible application defaults

### 06 - Static Website with Nginx

Location: `06-docker-static-site`

A static HTML and CSS site served from the lightweight `nginx:alpine` image.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\06-docker-static-site
docker build -t docker-static-site .
docker run --rm -p 8080:80 docker-static-site
```

Open `http://localhost:8080`.

Learning focus:

- Nginx document roots
- Lightweight Alpine images
- Static asset delivery
- Simple immutable web containers

### 07 - Multi-stage Flask Image

Location: `07-docker-multistage-flask`

A production-oriented Flask image that installs dependencies in a builder stage, copies them into a clean runtime stage, creates a non-root user, and serves the API with Gunicorn.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\07-docker-multistage-flask
docker build -t multistage-flask .
docker run --rm -p 5000:5000 multistage-flask
curl http://localhost:5000/health
```

Learning focus:

- Multi-stage builds
- Separation of build and runtime concerns
- Non-root container execution
- Gunicorn instead of the Flask development server

### 08 - Production-style Compose Stack

Location: `08-docker-prod-compose`

A three-service stack with Nginx as a reverse proxy, Flask as the API, and MySQL as the database. Separate frontend and backend networks restrict direct service communication, while a named volume persists database data.

```powershell
cd <YOUR_DIRECTORY>\week3-docker-kubernetes\08-docker-prod-compose
docker compose up --build -d
curl http://localhost:8080/
curl http://localhost:8080/db
curl http://localhost:8080/health
docker compose down
```

Learning focus:

- Reverse proxy configuration
- Frontend and backend network separation
- Service-to-service environment configuration
- Health checks and restart policies
- Persistent MySQL storage

## GitHub Actions and AWS

The repository-level workflows are stored in `.github/workflows` and are manually started with `workflow_dispatch`.

| Workflow | Purpose |
| --- | --- |
| `flask-api-docker-build.yml` | Builds the Flask API image and smoke-tests `/health`. |
| `flask-api-docker-build-aws.yml` | Authenticates through AWS OIDC, builds the image, and pushes commit SHA and `latest` tags to ECR. |
| `aws-oidc-test.yml` | Confirms that GitHub can assume the configured AWS role. |
| `terraform-ec2-docker.yml` | Checks, plans, and applies the EC2 Docker lab from Week 2. |
| `terraform-ec2-docker-destroy.yml` | Downloads the apply state artifact and destroys the EC2 lab resources. |

### Required GitHub Secret

Create this repository secret before running any AWS workflow:

```text
Name:  AWS_ROLE_ARN
Value: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<GITHUB_ACTIONS_ROLE_NAME>
```

In GitHub, go to `Settings > Secrets and variables > Actions > New repository secret`.

The workflows consume it as:

```yaml
role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
```

GitHub receives a short-lived AWS session through OIDC. No long-lived AWS access key or secret access key is required in the repository.

## Evaluation Notes

Strengths demonstrated by this portfolio:

- Clear progression from single-container builds to multi-service architecture
- Practical API health checks and persistent storage exercises
- Production-minded improvements through Gunicorn, non-root execution, health checks, and network separation
- AWS authentication through OIDC rather than stored access keys
- Separate manual Terraform apply and destroy workflows for cost control

Lab considerations:

- The Compose examples contain simple database passwords for local learning. Use secrets or an external secret manager outside a lab.
- MySQL port `3306` is published in project 02 for experimentation. It normally should remain internal.
- `depends_on` controls startup order but does not guarantee application readiness. Production stacks should add health-based dependency handling or connection retries.
- The workflow under `03-docker-volume-notes/.github/workflows` is educational source only. GitHub runs workflows only from the repository root `.github/workflows` directory.
- Images use pinned major/minor base tags for readability, but production builds should also consider digest pinning and vulnerability scanning.

## Cleanup

Stop and remove project containers when finished:

```powershell
docker compose down
docker ps -a
docker images
docker volume ls
```

Use `docker compose down -v` only when you intentionally want to remove a project's named volumes and persisted data.
