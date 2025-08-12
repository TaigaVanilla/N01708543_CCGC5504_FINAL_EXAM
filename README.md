# GitOps NGINX Application - n01708543

This project demonstrates a complete GitOps-based deployment workflow using NGINX, Docker, Kubernetes, Helm, ArgoCD, and GitHub Actions.

## 🏗️ Architecture Overview

```
GitHub Repository → GitHub Actions → Docker Hub → ArgoCD → Kubernetes Cluster
     ↓                    ↓            ↓         ↓           ↓
  Source Code    →   Build Image  →  Push   →  Deploy   →  Running App
```

## 📋 Prerequisites

- ✅ ArgoCD installed and configured
- ✅ k3s Kubernetes cluster running
- ✅ Docker Hub account
- ✅ GitHub repository
- ✅ Helm 3.x installed locally

## 🚀 Quick Start

### 1. Repository Setup

1. **Fork/Clone this repository**
   ```bash
   git clone https://github.com/TaigaVanilla/N01708543_CCGC5504_FINAL_EXAM.git
   cd nginx-gitops
   ```

### 2. Deploy the Application

#### Option A: Using ArgoCD (Recommended)
1. **Apply the ArgoCD Application**
   ```bash
   kubectl apply -f argocd/application.yaml
   ```

2. **Verify ArgoCD sync**
   ```bash
   kubectl get applications
   kubectl describe application nginx-gitops
   ```

#### Option B: Manual Helm Deployment
1. **Install the Helm chart**
   ```bash
   helm install nginx-gitops ./helm-chart
   ```

### 3. Deploy Monitoring Stack

1. **Add Prometheus Helm repository**
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

2. **Install Prometheus**
   ```bash
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace monitoring \
     --create-namespace
   ```

3. **Apply NGINX monitoring**
   ```bash
   kubectl apply -f monitoring/servicemonitor.yaml
   kubectl apply -f monitoring/nginx-dashboard-configmap.yaml
   ```

4. **Install Grafana**
   ```bash
   helm install grafana grafana/grafana \
     -f monitoring/grafana-values.yaml \
     --namespace monitoring \
     --create-namespace
   ```

## 🔍 Verification Commands

### Application Status
```bash
# Check pods
kubectl get pods -l app.kubernetes.io/name=nginx-gitops

# Check services
kubectl get svc -l app.kubernetes.io/name=nginx-gitops

# Check deployments
kubectl get deployments -l app.kubernetes.io/name=nginx-gitops

# View application logs
kubectl logs -l app.kubernetes.io/name=nginx-gitops -f
```

### ArgoCD Status
```bash
# Check ArgoCD applications
kubectl get applications

# View application details
kubectl describe application nginx-gitops

```

### Monitoring Status
```bash
# Check Prometheus pods
kubectl get pods -n monitoring -l app=prometheus

# Check Grafana pods
kubectl get pods -n monitoring -l app=grafana

# Get Grafana service
kubectl get svc -n monitoring grafana
```

### Access the Application
```bash
# Port forward to access NGINX
kubectl port-forward svc/nginx-gitops 8080:80

# Port forward to access Grafana
kubectl port-forward svc/grafana 3000:80 -n monitoring

# Port forward to access Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
```

## 📊 Grafana Dashboard

1. **Access Grafana**: http://localhost:3000
   - Username: `admin`
   - Password: `admin123`

2. **Custom Dashboard**: "NGINX GitOps Dashboard - n01708543"
   - Shows NGINX request rate
   - Displays response times
   - Pod status monitoring
   - Total request metrics

## 🔧 Configuration

### Helm Values
Key configuration options in `helm-chart/values.yaml`:

- **Image**: Docker image repository and tag
- **Replicas**: Number of NGINX pods
- **Resources**: CPU and memory limits
- **Service Type**: ClusterIP, NodePort, or LoadBalancer
- **Ingress**: Enable/disable ingress controller

### Environment Variables
The application can be configured via:

- **ConfigMaps**: For static configuration
- **Secrets**: For sensitive data
- **Environment Variables**: For runtime configuration


## 📈 Scaling

### Horizontal Pod Autoscaling
```bash
kubectl autoscale deployment nginx-gitops \
  --cpu-percent=80 \
  --min=2 \
  --max=10
```

### Manual Scaling
```bash
kubectl scale deployment nginx-gitops --replicas=5
```

## 🔒 Security

- **Network Policies**: Restrict pod-to-pod communication
- **RBAC**: Role-based access control
- **Pod Security Standards**: Enforce security policies
- **Image Scanning**: Scan Docker images for vulnerabilities
