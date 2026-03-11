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

/*
# We fetch the service details to get the LoadBalancer URL
data "kubernetes_service" "frontend" {
  metadata {
    name      = "horilla-frontend-service"
    namespace = "horilla"
  }
}

output "horilla_login_url" {
  description = "Automatic Link to Horilla Login Page"
  # Use try() to handle cases where the app isn't deployed yet
  value = try(
    "http://${data.kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].hostname}",
    "Deployment in progress... check again in 2 minutes."
  )
}
*/