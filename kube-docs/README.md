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

## 🚦 Step 0: Verify Cluster Status

Before you begin, make sure your Kubernetes cluster is up and running.

```bash
kubectl get nodes
```
You should see your nodes listed with a status of `Ready`.

---

## 📥 Step 1: Clone the Repository

You need to have the source code and Kubernetes configuration files on your machine (or the CI/CD environment).

```bash
git clone https://github.com/govindhan-ravi/horilla.git
cd horilla
git checkout 1.0
```

---

## 🛠️ Step 2: Build and Push Docker Images

Before deploying to Kubernetes, you need to build your images and push them to **Docker Hub**.

### 1. Login to Docker Hub
```bash
docker login
```

### 2. Build and Tag Backend
Replace `<your-username>` with your actual Docker Hub username.
```bash
docker build -t <your-username>/horilla-backend:latest -f Dockerfile.backend .
```

### 3. Build and Tag Frontend
```bash
docker build -t <your-username>/horilla-frontend:latest -f Dockerfile.frontend .
```

### 4. Push Images to Docker Hub
```bash
docker push <your-username>/horilla-backend:latest
docker push <your-username>/horilla-frontend:latest
```

> [!IMPORTANT]
> Make sure you have replaced `<dockerhub-username>` in `kube-docs/k8s/backend-deployment.yaml` and `kube-docs/k8s/frontend-deployment.yaml` with your actual username before proceeding to Step 3.

---

## 🚀 Step 3: Deploy to Kubernetes

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

## 🔍 Step 4: Verify the Deployment

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
