# 🏆 Master A-Z Deployment Guide: Horilla + Monitoring

This guide covers the **two most important steps** you mentioned to ensure a 100% error-free deployment.

## 🏁 Phase 1: The Clean Slate (Destroy)
If you have any old infrastructure running, clear it first to avoid conflicts.
1.  **Navigate to vpc folder**: `cd govindhan/vpc`
2.  **Run Destroy**: `terraform destroy -auto-approve`

---

## 🚀 Phase 2: The Full Automated Rollout (A-Z)
Now, run these commands in order. This will handle both the **Horilla App** and the **Monitoring Stack**.

### **Step 1: Initialize (Critical)**
```bash
terraform init
```
*This downloads the new Helm and Kubernetes providers.*

### **Step 2: Apply Everything**
```bash
terraform apply -auto-approve
```

---

## 🕒 Phase 3: What Happens Automatically
After running `apply`, just wait and watch your terminal:

1.  **EKS Creation (~15-20 mins)**: High-performance 3-node cluster is built.
2.  **Code Push (Instant)**: Your code is sent to GitHub automatically.
3.  **Monitoring Deploy (3 mins)**: Prometheus and Grafana are installed via Helm.
4.  **Horilla Deploy (5 mins)**: GitHub Actions builds your images and sends them to EKS.
5.  **The Result**: Your terminal will "Wake Up" and print your links!

---

## ✅ Phase 4: Access Your Infrastructure
Look for these two boxes at the end of your terminal:

### **1. Horilla HRMS**
- **URL**: `http://<your-loadbalancer>/login/`
- **Login**: `admin` / `admin`

### **2. Monitoring Dashboards**
- **URL**: `http://<your-grafana-link>`
- **User**: `admin`
- **Pass**: `prom-operator`

---

🏆 **Congratulations!** You now have a professional-grade, automated, and monitored infrastructure.
