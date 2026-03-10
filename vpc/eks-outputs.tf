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