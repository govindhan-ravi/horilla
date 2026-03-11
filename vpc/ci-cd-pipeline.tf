resource "local_file" "ci_cd_pipeline" {
  filename = "${path.module}/../.github/workflows/deploy.yml"
  content  = <<-EOT
# Build Timestamp: ${timestamp()} [FINAL VERIFICATION]
name: Horilla CI/CD Pipeline

on:
  push:
    branches:
      - main
      - 1.0
      - master
  workflow_dispatch: # This allows you to start the pipeline manually from GitHub UI

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: $${{ secrets.DOCKERHUB_USERNAME }}
        password: $${{ secrets.DOCKERHUB_TOKEN }}

    - name: Build and push backend image to Docker Hub
      uses: docker/build-push-action@v4
      with:
        context: ./horilla
        file: ./horilla/Dockerfile.backend
        push: true
        tags: govindhan1234/horilla-backend:$${{ github.sha }},govindhan1234/horilla-backend:latest

    - name: Build and push frontend image to Docker Hub
      uses: docker/build-push-action@v4
      with:
        context: ./horilla
        file: ./horilla/Dockerfile.frontend
        push: true
        tags: govindhan1234/horilla-frontend:$${{ github.sha }},govindhan1234/horilla-frontend:latest

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: $${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: $${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${var.aws_region}

    - name: Update kube config
      run: aws eks update-kubeconfig --name ${local.name}-${var.cluster_name} --region ${var.aws_region}

    - name: Deploy to EKS
      env:
        IMAGE_TAG: $${{ github.sha }}
      run: |
        # Update official manifests with a robust regex to ensure the new tag is applied
        sed -i "s|image:.*|image: govindhan1234/horilla-backend:$IMAGE_TAG|g" horilla/kube-docs/k8s/backend-deployment.yaml
        sed -i "s|image:.*|image: govindhan1234/horilla-frontend:$IMAGE_TAG|g" horilla/kube-docs/k8s/frontend-deployment.yaml
        
        # Apply namespace first, then everything else
        kubectl apply -f horilla/kube-docs/k8s/namespace.yaml
        kubectl apply -f horilla/kube-docs/k8s/
EOT
}

resource "null_resource" "git_push_trigger" {
  depends_on = [local_file.ci_cd_pipeline]

  triggers = {
    workflow_hash = local_file.ci_cd_pipeline.id
    always_run    = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ..
      git add --all
      git commit -m "Auto-trigger CI/CD from Terraform [EKS FIX]" || echo "Nothing to commit"
      git push origin master -f
    EOT
  }
}
