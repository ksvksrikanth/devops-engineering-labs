# DevOps Engineering Labs

This is a place to practice the everyday work of a DevOps engineer: setting up systems, deploying applications, writing scripts, and figuring out why something broke.

The folders are organized by topic, so you can start with Linux and Git or jump straight into a lab you need. Some areas have working examples; others are placeholders for future notes and exercises. The roadmap below includes both.

For a quick starting point, try the [Windows scripts](windows-powershell/README.md), [Linux scripts](linux-networking-git/scripts/README.md), or [shared Python tools](common-scripts/README.md). Each guide explains what to run and what to expect.

---

# Learning Goals

The main topics are:

- Linux administration and troubleshooting
- Networking fundamentals for DevOps
- Advanced Git workflows
- Terraform and Infrastructure as Code
- Ansible configuration management
- Docker and Kubernetes
- GitOps using Helm and ArgoCD
- GitHub Actions and CI/CD architecture
- Monitoring, Observability, and SRE
- AWS cloud architecture
- AI for DevOps
- Windows administration and PowerShell
- System design principles
- Deployment strategies
- Mock interviews and troubleshooting scenarios

---

# Repository Structure

```text
devops-engineering-labs/
├── linux-networking-git/
├── terraform/
├── ansible/
├── gitops/
├── cicd/
├── monitoring/
├── aws-ai/
├── revision/
├── windows-powershell/
├── architecture-notes/
├── interview-prep/
└── troubleshooting-journal/
```

---

# Local Development Environment Setup

## Base Environment

### Host OS
- Windows 11

### Linux Environment
- WSL2
- Ubuntu 24.04 LTS

### Development Tools
- VS Code
- Docker Desktop
- Git
- Python 3
- Terraform
- AWS CLI
- PowerShell 7
- kubectl
- kind
- helm
- ansible

---

# WSL Setup

## Verify WSL

```powershell
wsl --version
```

Example:

```text
WSL version: 2.7.3.0
Kernel version: 6.6.x
```

---

# Ubuntu Verification

```bash
uname -a
lsb_release -a
```

Example:

```text
Ubuntu 24.04 LTS
```

---

# PowerShell 7 Installation

## Install

```powershell
winget install --id Microsoft.PowerShell --source winget
```

## Verify

```powershell
pwsh
$PSVersionTable
```

Expected:

```text
PSVersion 7.x.x
PSEdition Core
```

---

# Git Installation and Configuration

## Verify Git

```bash
git --version
```

## Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

## Verify Git Configuration

```bash
git config --list
```

---

# Docker Desktop Setup

## Important Docker Settings

Enable:

```text
Settings → Resources → WSL Integration
```

Enable:
- Enable integration with my default WSL distro
- Ubuntu-24.04

---

# Docker Verification

```bash
docker ps
docker version
```

Expected:
- Docker Client section
- Docker Server section

---

# kubectl Installation

## Install

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

## Verify

```bash
kubectl version --client
```

---

# Kind Installation

## Install Stable Version

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

## Verify

```bash
kind version
```

---

# Create Kubernetes Cluster

## Create Cluster

```bash
kind create cluster --name devops-lab
```

## Verify Cluster

```bash
kubectl get nodes
kubectl cluster-info
```

## Useful Commands

```bash
kubectl get pods -A
kubectl get namespaces
kubectl get nodes -o wide
```

---

# Helm Installation

## Install

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## Verify

```bash
helm version
```

---

# Ansible Installation

## Install

```bash
sudo apt update
sudo apt install ansible -y
```

## Verify

```bash
ansible --version
```

---

# Additional Linux Utilities

## Install Utilities

```bash
sudo apt install -y \
curl \
wget \
jq \
net-tools \
dnsutils \
traceroute \
htop \
tree \
vim \
zip \
unzip
```

---

# VS Code Recommended Extensions

Install the following extensions:

| Extension | Purpose |
|---|---|
| Remote - WSL | WSL Integration |
| Docker | Docker Support |
| Kubernetes | Kubernetes Support |
| Terraform | Terraform Support |
| YAML | YAML Validation |
| GitLens | Git Visualization |
| GitHub Actions | CI/CD Workflow Support |
| PowerShell | PowerShell Development |
| Ansible | Ansible Playbook Support |

---

# Recommended Workflow

## Windows Layer

Used for:
- VS Code
- Browser
- Docker Desktop
- PowerShell
- Documentation

## Linux (WSL) Layer

Used for:
- kubectl
- Terraform
- Ansible
- Helm
- Git
- Docker CLI
- Bash scripting
- Kubernetes labs

---

# Productivity Aliases

## Add Aliases

Open:

```bash
vim ~/.bashrc
```

Add:

```bash
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias tf='terraform'
alias ll='ls -lah'
```

Reload:

```bash
source ~/.bashrc
```

---

# Learning Roadmap

# Linux + Networking + Git

## Linux
- Process Management
- Memory Troubleshooting
- Disk Troubleshooting
- Permissions
- systemd
- SSH
- Logs

## Networking
- DNS
- TCP/IP
- Ports
- Routing Basics
- curl
- traceroute
- netstat / ss

## Git
- Rebase vs Merge
- Cherry-pick
- Squash
- Branching Strategies
- Conflict Resolution

## Interview Topics
- High CPU troubleshooting
- Memory leak investigation
- Disk full issues
- SSH debugging
- DNS troubleshooting

---

# Terraform

## Terraform
- Modules
- State Management
- Remote Backend
- Workspaces
- Dynamic Blocks
- for_each
- count
- Dependencies

## Enterprise Topics
- Reusable module architecture
- Multi-environment setup
- State locking
- Drift detection

# Ansible

Ansible exercises are kept separately in [ansible/](ansible/README.md).

## Topics
- Inventory
- Playbooks
- Roles
- Variables
- Templates
- Vault
- Handlers
- Dynamic inventory

## Hands-On
- AWS Infrastructure
- EC2
- VPC
- Security Groups
- S3 Backend
- Server Configuration

---

# Docker + Kubernetes

Labs are now in [container-platform-labs](../container-platform-labs/README.md) at `D:\container-platform-labs`.

## Docker
- Dockerfile Optimization
- Layers
- Volumes
- Networking
- Multi-stage Builds

## Kubernetes
- Pods
- Deployments
- Services
- Ingress
- ConfigMaps
- Secrets
- Namespaces

## Hands-On
- Python Application Deployment
- NGINX Deployment
- Monitoring Stack

---

# Kubernetes Advanced + GitOps

## Advanced Kubernetes
- Scheduler
- etcd
- kubelet
- HPA
- StatefulSets
- RBAC
- Network Policies

## GitOps
- Helm
- ArgoCD

## Hands-On
- EKS Cluster
- GitOps Deployment Flow
- Helm-based Deployments

---

# GitHub Actions + CI/CD

## GitHub Actions
- Reusable Workflows
- Matrix Builds
- Secrets
- OIDC
- Self-hosted Runners

## CI/CD Architecture
- Blue-Green Deployment
- Canary Deployment
- Rollback Strategies
- Artifact Management
- Environment Approvals

## Hands-On
- Terraform CI/CD
- Kubernetes Deployment Pipelines

---

# Monitoring + Observability + SRE

## Monitoring
- Prometheus
- Grafana

## Logging
- Loki
- ELK Stack

## SRE
- SLI/SLO/SLA
- Incident Management
- RCA

## Hands-On
- Monitoring Dashboards
- Alerts
- Kubernetes Observability

---

# AWS Architecture + AI for DevOps

## AWS
- VPC
- IAM
- EC2
- Auto Scaling
- Load Balancers
- S3
- RDS

## AI for DevOps
- Prompt Engineering
- AI Troubleshooting
- AI-assisted Automation
- MCP Basics
- AI Agents
- AI Governance

## Hands-On
- AI Log Summarizer
- AI Deployment Assistant

---

# Revision + Mock Interviews

## Revision
- Kubernetes
- Terraform
- CI/CD
- Monitoring
- Linux

## Mock Interviews
- Scenario-based Questions
- Troubleshooting Rounds
- Architecture Rounds
- Leadership Discussions

---

# Windows + PowerShell Module

## Windows Topics
- Services
- Event Viewer
- IIS Basics
- Task Scheduler
- Networking Commands
- Performance Troubleshooting

## PowerShell Topics
- Scripting Fundamentals
- Functions
- Loops
- Objects and Pipelines
- API Calls
- JSON Handling
- Remoting
- Automation Scripts

## Enterprise Automation
- IIS Deployments
- PowerShell CI/CD
- Windows Health Checks
- Server Automation

---

# Practices to build into the labs

As you work through the labs, pay attention to these habits:

- Infrastructure as Code standards
- CI/CD best practices
- Deployment strategies
- GitOps principles
- Security best practices
- Observability standards
- Production troubleshooting methodology
- Logging strategies
- Secrets management
- Automation standards
- Release engineering principles
- High availability architecture
- Scalability principles
- Disaster recovery concepts
- Reliability engineering

---

# Deployment strategies to practice

- Rolling Updates
- Blue-Green Deployments
- Canary Deployments
- Recreate Strategy
- Feature Flags
- Rollback Strategies
- Progressive Delivery

---

# System design topics

- Scalability
- High Availability
- Reliability
- Fault Tolerance
- Observability
- Security
- Disaster Recovery
- Performance Optimization
- Infrastructure Design
- CI/CD Architecture Design

---

# Interview Preparation

Use the labs as a starting point for interview practice:

- Mock Interviews
- Scenario-based Questions
- Troubleshooting Discussions
- Architecture Discussions
- Leadership Questions
- Resume Preparation
- STAR Format Discussions
- Real-world Incident Analysis

---

# Troubleshooting Journal

Maintain notes inside:

```text
troubleshooting-journal/
```

Document:
- Errors
- Fixes
- Commands
- Observations
- RCA notes
- Architecture decisions and what you learned
- Interview answers

This becomes:
- Revision material
- Personal knowledge base
- Interview preparation material

---

# AI Tools Recommended

- ChatGPT
- Claude
- GitHub Copilot

These tools will be used for:
- AI-assisted troubleshooting
- YAML generation
- Documentation generation
- Script generation
- RCA assistance
- Automation workflows

---

# Goal of This Repository

The aim is to understand what you run, explain why it works, and know where to look when it fails. Keep notes on the mistakes and fixes along the way; those are useful both on the job and in interviews.

---

# Where to start

The setup notes above describe the local environment used for these labs. Check the prerequisites on your own machine, then choose an exercise. If you are starting from scratch, Linux, networking, and Git are a good first stop.


## Basic DevOps automation

- [Windows PowerShell scripts](windows-powershell/README.md): HTTP, Windows services, WinRM remote operations, and system health.
- [Linux Bash scripts](linux-networking-git/scripts/README.md): HTTP, systemd services, SSH remote operations, and system health.

## Common Windows and Linux automation

See [cross-platform DevOps scripts](common-scripts/README.md) for disk alerts, HTTP/TCP health checks, log retention cleanup, CPU/RAM CSV metrics, environment/config validation, and timestamped ZIP backups. The guide includes setup steps, examples, and tests you can run locally.

## Certificate updates

Native PowerShell and Bash certificate update scripts. See the [certificate update guide](certificate-guide.md) for CA trust updates, TLS replacement, preview/apply commands, rollback behavior, and platform requirements. Start with the default preview to see what would change before applying an update.
