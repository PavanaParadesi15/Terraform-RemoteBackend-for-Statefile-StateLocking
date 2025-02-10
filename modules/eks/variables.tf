variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  
}

variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  
}


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to launch the EKS cluster into"
  type        = list(string)
  
}

variable "region" {
  description = "The AWS region to launch the EKS cluster"
  type        = string
  // default     = "us-west-2"
  
}

// Define the node group configuration , how many worker nodes we need to launch
variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}