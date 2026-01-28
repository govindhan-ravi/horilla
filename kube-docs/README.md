# Horilla Kubernetes Deployment Guide 🚀

This guide provides step-by-step instructions on how to deploy the Horilla HRMS application to a Kubernetes (K8s) cluster.

## 🏗️ Architecture Ovenview

The application is split into three main components:
1.  **Backend:** Django application served via Gunicorn.
2.  **Frontend:** Nginx serving static files and acting as a reverse proxy.
3.  **Database:** PostgreSQL for persistent data storage.

---

## 📂 Directory Structure

```text
horilla/
├── Dockerfile.backend       # Build for Django (server)
├── Dockerfile.frontend      # Build for Nginx (static files)
└── kube-docs/
    └── k8s/
        ├── namespace.yaml           # Isolation for horilla app
        ├── configmap.yaml           # Environment variables
        ├── pvc.yaml                 # Storage for DB and Media
        ├── db-deployment.yaml       # Database Pod
        ├── db-service.yaml          # Internal DB Service
        ├── backend-deployment.yaml   # Django Pods (2 replicas)
        ├── backend-service.yaml      # Internal Backend Service
        ├── frontend-deployment.yaml  # Nginx Pods (2 replicas)
        └── frontend-service.yaml     # NodePort External Service
```

---

## 🛠️ Step 1: Build Docker Images

Before deploying to Kubernetes, you need to build and push your images to a registry (or load them into your cluster nodes).

### Build Backend
```bash
docker build -t horilla-backend:latest -f Dockerfile.backend .
```

### Build Frontend
```bash
docker build -t horilla-frontend:latest -f Dockerfile.frontend .
```

---

## 🚀 Step 2: Deploy to Kubernetes

Run the following commands in order:

### 1. Create the Namespace
```bash
kubectl apply -f kube-docs/k8s/namespace.yaml
```

### 2. Set up Configuration and Storage
```bash
kubectl apply -f kube-docs/k8s/configmap.yaml
kubectl apply -f kube-docs/k8s/pvc.yaml
```

### 3. Deploy the Database
```bash
kubectl apply -f kube-docs/k8s/db-deployment.yaml
kubectl apply -f kube-docs/k8s/db-service.yaml
```

### 4. Deploy the Backend
```bash
kubectl apply -f kube-docs/k8s/backend-deployment.yaml
kubectl apply -f kube-docs/k8s/backend-service.yaml
```

### 5. Deploy the Frontend
```bash
kubectl apply -f kube-docs/k8s/frontend-deployment.yaml
kubectl apply -f kube-docs/k8s/frontend-service.yaml
```

---

## 🔍 Step 3: Verify the Deployment

Check if everything is running correctly:

```bash
# Check Pods
kubectl get pods -n horilla

# Check Services
kubectl get svc -n horilla
```

### Accessing the App
The frontend is exposed via **NodePort 30080**. You can access it at:
`http://<NODE_IP>:30080`

---

## 💡 Key Concepts for Beginners
- **Replicas:** We use `replicas: 2` for the frontend and backend to ensure the app stays up even if one pod crashes.
- **Services:** These allow pods to talk to each other using internal names (e.g., `horilla-db-service`) instead of unstable IP addresses.
- **Persistent Volume Claims (PVC):** These ensure that your database data and uploaded media are saved even if pods are restarted.
