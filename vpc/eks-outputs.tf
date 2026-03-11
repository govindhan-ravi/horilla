# ---------------------------------------------
# EKS Outputs
# ---------------------------------------------

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Cluster Security Group"
  value       = module.eks.cluster_security_group_id
}

# ---------------------------------------------
# App Access Output
# ---------------------------------------------
# This data source waits for the display_final_output script to finish
# (which itself waits for GitHub Actions to deploy the app).
# By the time this runs, the LoadBalancer will exist.

data "kubernetes_service" "frontend" {
  depends_on = [null_resource.display_final_output]
  metadata {
    name      = "horilla-frontend-service"
    namespace = "horilla"
  }
}

output "horilla_login_url" {
  description = "Horilla Login Page URL"
  # Use try() to handle cases where the LoadBalancer isn't fully ready yet
  value = try(
    "http://${data.kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].hostname}/login/",
    "Deployment in progress... LoadBalancer is warming up. Please wait 2 minutes and run 'terraform apply' again to see the link."
  )
}