# ---------------------------------------------
# EKS Variables
# ---------------------------------------------

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "terraform-eks-cluster"
}

variable "cluster_version" {
  description = "EKS Kubernetes Version"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "Worker Node Instance Type"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired Node Count"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum Node Count"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum Node Count"
  type        = number
  default     = 1
}