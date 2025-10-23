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
<img width="1536" height="1024" alt="SIngle node kubernetes diagram" src="https://github.com/user-attachments/assets/0a8becb2-e302-466e-a9dd-9ad446e840a9" />



📋 Project Structure
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
## ⚡ Prerequisites

- Docker
    
- Minikube
    
- kubectl
    
- (Optional) Helm for advanced deployments

## 🚀 Setup Instructions

1. **Start Minikube with Docker driver**:
	```bash
	minikube start --driver=docker
	```
2. **Apply Kubernetes manifests**:
	```bash
	kubectl apply -f k8s/deployments/
	kubectl apply -f k8s/services/
	kubectl apply -f k8s/configmaps-secrets/
	kubectl apply -f k8s/pvc.yaml
	kubectl apply -f k8s/ingress.yaml
	```
3. **Check pods, services, and ingress**:
	```bash
	kubectl get pods
	kubectl get svc
	kubectl get ingress
	```
4. **Access the application** via browser:
	```
	minikube tunnel
	```
	Open the browser at the configured **Ingress host URL**.

## 🔧 Features Practiced

- Multi-service deployments on Kubernetes
    
- Manual configuration of Deployments, Services, and Ingress
    
- Persistent storage with PVC
    
- ConfigMaps and Secrets for environment variables
    
- Pod scaling and rolling updates
-
## 🧩 Learning Outcomes

- Hands-on experience with single-node Kubernetes clusters
    
- Practical knowledge of deploying multi-container applications
    
- Understanding Kubernetes resource management and debugging
    
- Best practices for configuration and persistent storage

## 📌 References

- Kubernetes Official Docs
    
- Minikube Official Docs
    
- Docker Official Docs

## License

This project is open-source and available under the MIT License
