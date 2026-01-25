# Titanic API – Secure Kubernetes Deployment on AWS (EKS)

This project demonstrates a production-style deployment of a Flask API using Docker, Kubernetes, AWS EKS, CI/CD, monitoring, and security best practices.

The goal is to show end-to-end DevOps execution with emphasis on:

* Security
* Observability
* Automation
* Defense-in-depth

## Architecture Overview

* Flask API (Titanic ML API)
* Docker containerization
* GitHub Actions CI/CD
* AWS EKS (via Terraform)
* Kubernetes (Deployments, Secrets, NetworkPolicy)
* Prometheus & Grafana monitoring

---

## Step 1: Clone the Repository

Clone the project locally to begin.

```bash
git clone https://github.com/<your-username>/titanic-api.git
cd titanic-api
```
![Git clone Screenshot]
![](<Git clone Screenshot.png>)

---

## Step 2: Flask Application Setup

The Flask app is structured using an application factory pattern for scalability.

Key files:

* `run.py` – entry point
* `src/app.py` – Flask app factory
* `src/views/` – API routes
* `src/models/` – data models

Test locally (optional):

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
```
![Copied flasked Screenshot]
![](<Copied flaskapp code into repo Screenshot .png>)

![Flask app on browser Screenshot]
![](Flask app on browser Screenshot .png)

---

## Step 3: Dockerfile Creation

The application is containerized using Docker with security best practices:

* Non-root user
* Explicit dependencies
* Gunicorn for production
* Controlled temp directory

Build the image:

```bash
docker build -t titanic-api:latest .
```

Run locally:

```bash
docker run -p 5000:5000 titanic-api:latest
```

![Docker file created screenshot]
![](<Docker file created Screenshot.png>)

![Docker runnings screenshot]
![](Docker running Screenshot .png)

![Docker contact screenshot]
![](docker containers created & running Screenshot.png)
---

## Step 4: Docker Image Management

Verify the image locally and push to Docker Hub.

```bash
docker tag titanic-api:latest <dockerhub-username>/titanic-api:latest
docker push <dockerhub-username>/titanic-api:latest
```

![Container image in Docker Desktop Screenshot]
![](contanier image in docker desktop Screenshot .png)

![Docker images created by build in Docker Desktop Screenshot]
![](docker images created by build in docker desktop Screenshot .png)

---

## Step 5: CI Pipeline with GitHub Actions

A CI pipeline was created to:

* Install dependencies
* Run tests
* Build Docker image
* Push image to Docker Hub

Workflow file:

* `.github/workflows/ci.yml`

Secrets configured in GitHub:

* `DOCKER_USERNAME`
* `DOCKER_PASSWORD`


![GitHub CI Workflow Created Screenshot]
![alt text](Github CI Workflow Created  Screenshot.png)

![GitHub Action test job ran success Screenshot]
![](Github action test job ran success Screenshot .png)

---

## Step 6: CD Pipeline (Automated Deployment)

The CD pipeline deploys the image to Kubernetes after a successful build.

```bash
kubectl apply -f k8s/
```

📸 Screenshot:
![GitHub Action secret config for CD Screenshot]
![](github action secret config for cd Screenshot .png)

![GitHub Action deployment success Screenshot]
![](Github action deployment succes Screenshot .png)

![Roll back deployment success Screenshot]
![](Roll back deployment success Screenshot .png)


---

## Step 7: EKS Cluster Provisioning with Terraform

The Kubernetes cluster was provisioned using Terraform.

first you create all the terraform  files.
main.tf
outputs.tf
providers.tf
variables.tf

```bash
terraform init
terraform plan
terraform apply
```

This creates:

* EKS cluster
* Node groups
* IAM roles
* VPC networking

![Terraform apply complete for eks creation screenshot]
![](Terraform apply complete for eks creation screenshot .png)

![EKS creation screenshot]
![](eks cluster on aws dashboard Screenshot.png)

---

## Step 8: Kubernetes Deployment

The application is deployed using a Kubernetes Deployment and Service.

```bash
kubectl apply -f titanic-api-deployment.yaml
kubectl get pods
```
![kubectl apply -f k8s deployment success Screenshot]
![](kubectl apply -f k8s deployment success Screenshot .png)

![All pods running success from terminal Screenshot]
![](All pods running success from terminal Screenshot .png)

![Titanic API running on Kubernetes confirmation Screenshot]
![](Titanic Api running on kubernetes confirmation Screenshot .png)
---

## Step 9: Secrets Management

Database credentials are stored securely using Kubernetes Secrets.

```bash
kubectl create secret generic titanic-db-secret \
  --from-literal=POSTGRES_USER=admin \
  --from-literal=POSTGRES_PASSWORD=********
```

Secrets are injected as environment variables.

![secret for database credentials Screenshot]
![](secret for database credentials Screenshot .png)

---

## Step 10: Network Security (NetworkPolicy)

NetworkPolicies restrict pod-to-pod communication.

```bash
kubectl apply -f titanic-api-network.yaml
```

Only approved namespaces and ports can access the API.

---

## Step 11: TLS / SSL & Database Encryption

TLS and encryption configuration files were created to:

* Secure API traffic
* Encrypt database connections

![created file for TLS and SSL security Screenshot]
![](created file for TLS and SSL security Screenshot .png)

![file for database encryption Screenshot]
![](file for database encryption Screenshot .png)

---

## Step 12: Monitoring with Prometheus & Grafana

Monitoring stack installed via Helm.

```bash
helm install prometheus prometheus-community/kube-prometheus-stack
```

Metrics collected:

* CPU
* Memory
* Pod health

![prometheus & grafana installation Screenshot]
![](prometheus & grafana installation Screenshot .png)

![data source prometheus added Screenshot]
![](data source prometheus added Screenshot .png)

![prometheus node cpu usage metrics Screenshot]
![](prometheus node cpu usage metrics  Screenshot .png)

---

## Step 13: Advanced Kubernetes Features

Implemented:

* HPA (Horizontal Pod Autoscaler)
* PDB (Pod Disruption Budget)
* NetworkPolicy hardening

![Advanced features and HPA, PDB, NetworkPolicy Screenshot]
![](Advanced features and HPA, PDB, NetworkPolicy Screenshot .png)
---

## Security Summary

* Non-root containers
* Secrets never hardcoded
* Network isolation
* CI image build automation
* Observability enabled
* Rollback supported

---

## Conclusion

This project demonstrates a real-world Kubernetes deployment with:

* Secure CI/CD
* Cloud-native infrastructure
* Production-grade monitoring
* Compliance-aware design
