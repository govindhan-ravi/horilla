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

output "horilla_login_status" {
  description = "Application Status"
  value       = "Deployment is running in the background. Check the 'display_final_output' script logs above for the live URL!"
}