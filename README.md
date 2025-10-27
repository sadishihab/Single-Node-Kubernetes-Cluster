# Single-Node Kubernetes Cluster

[![Minikube](https://img.shields.io/badge/Minikube-v1.30.1-blue)](https://minikube.sigs.k8s.io/docs/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.28.0-blue)](https://kubernetes.io/docs/home/)
[![Docker](https://img.shields.io/badge/Docker-v24.0.5-blue)](https://docs.docker.com/)
[![MIT License](https://img.shields.io/badge/MIT-License-blue)](https://opensource.org/licenses/MIT)


## Overview

The project demonstrates:

- Setting up a **local Kubernetes cluster** using Minikube (Docker driver).
- Deploying a **multi-container application** consisting of:
  - Frontend
  - Backend
  - MongoDB database
- Configuring **Deployments**, **Services**, and **Ingress** manually.
- Managing **persistent storage** with PVC for MongoDB.
- Using **ConfigMaps** and **Secrets** to manage environment variables.
- Exposing the application via **Ingress** for browser access.
- Practicing **scaling pods** and **rolling updates**.


## Architecture Diagram
```pgsql
                   ┌────────────────────────────┐
                   │      Browser / User        │
                   └──────────────┬─────────────┘
                                  │
                                  ▼
                        ┌──────────────────┐
                        │     Ingress      │
                        │ (NGINX / Rules)  │
                        └───────┬──────────┘
                                │
                ┌───────────────┴────────────────┐
                │                                │
                ▼                                ▼
     ┌───────────────────┐             ┌───────────────────┐
     │   Frontend Pod    │             │   Backend Pod     │
     │ (React / Node.js) │◄──────────►│ (Node.js / API)   │
     │   ClusterIP SVC   │             │   ClusterIP SVC   │
     └────────┬──────────┘             └────────┬──────────┘
              │                                 │
              │                                 ▼
              │                     ┌───────────────────┐
              │                     │   MongoDB Pod     │
              │                     │ (Database Layer)  │
              │                     │ Persistent Volume │
              │                     └────────┬──────────┘
              │                              │
              │                     ┌───────────────────┐
              │                     │ PVC + PV (Storage)│
              │                     └───────────────────┘
              │
   ┌──────────────────────────┐
   │ ConfigMaps & Secrets     │
   │ (Env vars, credentials)  │
   └──────────────────────────┘

   [ Single-node Minikube cluster (Docker driver) ]

```



Project Structure
```graphql
.
├── frontend/               # Frontend application code
├── backend/                # Backend application code
├── k8s/                    # Kubernetes manifests
│   ├── deployments/        # Deployment YAML files
│   ├── services/           # Service YAML files
│   ├── ingress.yaml        # Ingress configuration
│   ├── pvc.yaml            # Persistent Volume Claim for MongoDB
│   └── configmaps-secrets/ # ConfigMaps and Secrets YAMLs
└── README.md

```
## Prerequisites

- Docker
    
- Minikube
    
- kubectl
    
- (Optional) Helm for advanced deployments

## Setup Instructions

1. **Start Minikube with Docker driver**:
	```bash
	minikube start --driver=docker
 	eval $(minikube docker-env)
	```
2. **Apply Kubernetes manifests**:
   
   Apply ConfigMaps and Secrets
	```bash
 	kubectl apply -f k8s/app-configmap.yaml
	kubectl apply -f k8s/app-secret.yaml
	```
 	Apply MongoDB storage and deployment
	```bash
 	kubectl apply -f k8s/mongo-pv.yaml
	kubectl apply -f k8s/mongo-pvc.yaml
	kubectl apply -f k8s/mongo-storage-setup.yaml
	kubectl apply -f k8s/mongo.yaml
	```
	Apply application deployments
	```bash
	kubectl apply -f k8s/backend.yaml
	kubectl apply -f k8s/frontend.yaml
	```
	Apply Ingress  
	```bash
	kubectl apply -f k8s/ingress.yaml
	```
 
4. **Check pods, services, and ingress**:
	```bash
	kubectl get pods
	kubectl get svc
	kubectl get ingress
	```
5. **Access the application** via browser:
	```
	minikube tunnel
	```
	Open the browser at the configured **Ingress host URL**.

## Kubernetes Management Script — k8s-manage.sh

An all-in-one automation script to simplify Kubernetes environment management — enabling you to stop, start, backup, or restore all deployments and services across namespaces.

**Features**  

- Stop All Deployments: Scales all deployments to 0 replicas (and saves replica counts).
- Start Deployments: Restores deployments to their previous replica counts.
- Backup: Saves deployments and services (YAML) per namespace to ./k8s-backups.
- Restore: Recreates namespaces, deployments, and services from backups.
- Namespace Filtering: Run operations on specific namespaces only.

**Usage**  
Stop all deployments and save replica states
```bash
./k8s-manage.sh --stop
```
Restart all deployments from saved replicas
```bash
./k8s-manage.sh --start
```
Backup all deployments & services
```bash
./k8s-manage.sh --save
```
Restore from previous backups
```bash
./k8s-manage.sh --restore
```
Operate on a single namespace
```bash
./k8s-manage.sh --stop my-namespace
```

Backup Structure:  
```markdown
k8s-backups/
├── dev_20251026-1420/
│   ├── deployments.yaml
│   ├── services.yaml
│   └── replicas.txt
└── prod_20251026-1420/
    ├── deployments.yaml
    ├── services.yaml
    └── replicas.txt
```

Requirements:  
- kubectl configured for the target cluster
- jq installed (for JSON parsing)

## Features Practiced

- Multi-service deployments on Kubernetes
    
- Manual configuration of Deployments, Services, and Ingress
    
- Persistent storage with PVC
    
- ConfigMaps and Secrets for environment variables
    
- Pod scaling and rolling updates
-
## Learning Outcomes

- Hands-on experience with single-node Kubernetes clusters
    
- Practical knowledge of deploying multi-container applications
    
- Understanding Kubernetes resource management and debugging
    
- Best practices for configuration and persistent storage

## References

- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [Minikube Official Docs](https://minikube.sigs.k8s.io/docs/)
- [Docker Official Docs](https://docs.docker.com/)

## License

This project is open-source and available under the **MIT License**
