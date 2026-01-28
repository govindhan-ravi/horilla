# Horilla Kubernetes Deployment Guide 🚀

Welcome! This folder contains everything you need to take the Horilla HRMS from a local development set up to a **production-ready Kubernetes cluster**.

---

## 📂 Folder Structure

- **`Dockerfile.backend`**: Instructions to build the Django app image.
- **`Dockerfile.frontend`**: Instructions to build the Nginx (web server) image.
- **`nginx.conf`**: The "brain" of the frontend; tells Nginx how to talk to the backend.
- **`setup_ec2.sh`**: A "one-click" script to prepare your Ubuntu EC2 instance.
- **`k8s/`**: Kubernetes "Manifests" (The blueprints for your cluster).
  - `namespace.yaml`: Creates a dedicated "room" for Horilla.
  - `db-deployment.yaml`: Sets up the PostgreSQL database.
  - `backend-deployment.yaml`: Sets up the Django application.
  - `frontend-deployment.yaml`: Sets up the Nginx web server.
  - `pvc.yaml`: Ensures your data isn't lost if a container restarts.
  - `configmap.yaml`: Stores settings like database URLs.

---

## 🛠️ Step-by-Step Installation

### Phase 1: Prepare the EC2 Instance
1. **SSH into your EC2**: `ssh -i your-key.pem ubuntu@ec2-public-ip`
2. **Run the Setup Script**:
   ```bash
   chmod +x setup_ec2.sh
   ./setup_ec2.sh
   ```
3. **Relogin**: Exit the SSH session and log back in. This refreshes your user permissions so you can run `docker` without `sudo`.

### Phase 2: Building the Images
Since we are using **Minikube** (a local K8s cluster), we need to tell it about our custom images.
1. **Build them**:
   ```bash
   docker build -t horilla-backend:latest -f Dockerfile.backend .
   docker build -t horilla-frontend:latest -f Dockerfile.frontend .
   ```
2. **Load them into Minikube**:
   ```bash
   minikube image load horilla-backend:latest
   minikube image load horilla-frontend:latest
   ```

### Phase 3: Launching the Cluster
Use the "Apply" command to tell Kubernetes to look at your manifests and make them a reality.
```bash
kubectl apply -f k8s/
```
Check if they are running:
```bash
kubectl get pods -n horilla
```

---

## 🎓 Why are we doing this? (The "Teaching" Bit)

### 1. Why Docker?
Imagine you have a cake recipe. Docker is the **Pre-packaged Cake Mix**. Instead of hoping the person baking the cake has the right oven, the right flour, and the right temperature, you give them a box that has *everything* inside.
- **`Dockerfile.backend`**: Packages the Python code, the libraries (Postgres client, Gunicorn), and the OS requirements.
- **`Dockerfile.frontend`**: Packages Nginx, which is much faster at serving images and CSS than Django is.

### 2. Why Nginx (Frontend Service)?
In production, you never let users talk directly to Django. It’s like a restaurant where the Chef (Django) doesn't talk to customers. The Waiter (**Nginx**) takes the order, serves the static appetizers (CSS/JS files), and only goes to the Chef for the "hot" data (Database queries).
- **Benefit**: It’s faster, more secure, and handles high traffic better.

### 3. Why Kubernetes (K8s)?
If Docker is the "Boxed Cake Mix", Kubernetes is the **Industrial Bakery**. 
- **Auto-healing**: If the backend crashes at 3 AM, K8s notices and restarts it instantly.
- **Scaling**: If 1,000 people log in at once, K8s can spin up 5 backends to handle the load.
- **Service Discovery**: The backend doesn't need to know the IP address of the Database; it just looks for a service named `horilla-db-service`.

### 4. Why PVC (Persistent Volume Claims)?
Containers are "disposable". If you delete a container, its files are gone. **PVCs** are like **External Hard Drives**. Even if the database container dies, the data stays safe on the disk, ready for the next container to plug in.

---

## 🖥️ Viewing the Output
We used a **NodePort** service on port **30080**.
1. Open your AWS Console -> EC2 -> Security Groups.
2. Edit Inbound Rules -> Add **Custom TCP**, Port **30080**, Source **My IP**.
3. Visit: `http://<EC2-PUBLIC-IP>:30080`

**Congratulations! You are now running a production-grade containerized HRMS!**
