resource "local_file" "k8s_manifest" {
  filename = "${path.module}/k8s-manifest.yaml"
  content  = <<-EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: horilla-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: horilla-backend
  template:
    metadata:
      labels:
        app: horilla-backend
    spec:
      containers:
      - name: horilla-backend
        image: IMAGE_PLACEHOLDER_BACKEND
        ports:
        - containerPort: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: horilla-backend
spec:
  selector:
    app: horilla-backend
  ports:
  - port: 8000
    targetPort: 8000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: horilla-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: horilla-frontend
  template:
    metadata:
      labels:
        app: horilla-frontend
    spec:
      containers:
      - name: horilla-frontend
        image: IMAGE_PLACEHOLDER_FRONTEND
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: horilla-frontend
spec:
  type: LoadBalancer
  selector:
    app: horilla-frontend
  ports:
  - port: 80
    targetPort: 80
EOT
}
