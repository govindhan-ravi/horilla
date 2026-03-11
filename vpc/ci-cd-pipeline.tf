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

resource "null_resource" "display_final_output" {
  depends_on = [null_resource.git_push_trigger]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<-EOT
      Write-Host "===================================================================" -ForegroundColor Cyan
      Write-Host "🚀 Terraform provisioning complete! Automated deployment started..." -ForegroundColor Cyan
      Write-Host "⏳ Waiting for GitHub Actions to build and deploy your app (This takes ~5-10 minutes)." -ForegroundColor Yellow
      Write-Host "===================================================================" -ForegroundColor Cyan

      Start-Sleep -Seconds 120

      $lb_hostname = ""
      for ($i=1; $i -le 30; $i++) {
          aws eks update-kubeconfig --name sap-dev-terraform-eks-cluster --region us-east-1 2>$null | Out-Null
          $svc = kubectl get svc horilla-frontend-service -n horilla -o json 2>$null | ConvertFrom-Json 2>$null
          if ($null -ne $svc -and $null -ne $svc.status -and $null -ne $svc.status.loadBalancer -and $null -ne $svc.status.loadBalancer.ingress) {
              $lb_hostname = $svc.status.loadBalancer.ingress[0].hostname
          }
          if ($lb_hostname) {
              break
          }
          Write-Host "Deploying to EKS and waiting for LoadBalancer... (Attempt $i/30)" -ForegroundColor Gray
          Start-Sleep -Seconds 30
      }

      Write-Host "`n===================================================================" -ForegroundColor Green
      Write-Host "🎉 DEPLOYMENT SUCCESSFUL! 🎉" -ForegroundColor Green
      Write-Host "===================================================================" -ForegroundColor Green
      Write-Host "The Final Result You Will Get:" -ForegroundColor White
      Write-Host "Your application is LIVE here: 👉 http://$lb_hostname/login/" -ForegroundColor Cyan
      Write-Host "`nLogin Details:" -ForegroundColor White
      Write-Host "Username: admin" -ForegroundColor Yellow
      Write-Host "Password: admin" -ForegroundColor Yellow
      Write-Host "You are now in full control with minimum effort. Great job setting up this professional environment! 🏆🚀" -ForegroundColor Green
      Write-Host "===================================================================" -ForegroundColor Green
    EOT
  }
}
