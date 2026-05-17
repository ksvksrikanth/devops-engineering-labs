# DevOps-Learning

A structured hands-on DevOps, Cloud, Kubernetes, CI/CD, Platform Engineering, AI-for-DevOps, and Interview Preparation learning repository.

This repository is designed to:
- Learn modern DevOps engineering deeply
- Practice hands-on labs
- Build troubleshooting mindset
- Prepare for senior DevOps interviews
- Understand enterprise architecture patterns
- Learn CI/CD and deployment strategies
- Learn Infrastructure as Code and GitOps
- Build AI-assisted DevOps workflows

---

# Learning Goals

This repository will help cover:

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
DevOps-Learning/
├── week1-linux-networking-git/
├── week2-terraform-ansible/
├── week3-docker-kubernetes/
├── week4-gitops/
├── week5-cicd/
├── week6-monitoring/
├── week7-aws-ai/
├── week8-revision/
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

# Week 1 — Linux + Networking + Git

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

# Week 2 — Terraform + Ansible

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

## Ansible
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

# Week 3 — Docker + Kubernetes

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

# Week 4 — Kubernetes Advanced + GitOps

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

# Week 5 — GitHub Actions + CI/CD

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

# Week 6 — Monitoring + Observability + SRE

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

# Week 7 — AWS Architecture + AI for DevOps

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

# Week 8 — Revision + Mock Interviews

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

# DevOps Best Practices Included

Throughout the journey, the following best practices will be covered:

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

# Deployment Strategies Covered

- Rolling Updates
- Blue-Green Deployments
- Canary Deployments
- Recreate Strategy
- Feature Flags
- Rollback Strategies
- Progressive Delivery

---

# System Design Principles Included

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

This repository also includes:

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
- Architecture learnings
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

The goal is not just to learn tools.

The goal is to become:
- a strong DevOps engineer,
- a better troubleshooter,
- a platform engineering thinker,
- and an interview-ready senior engineer.

---

# Status

✅ Environment Setup Completed

Next Step:

🚀 Start Week 1 — Linux + Networking + Git

