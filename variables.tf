variable "region" {
  description = "The region in which the VPC will be created."
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file."
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to store the Terraform state lock."
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}


variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  
}

variable "subnet_ids" {
  description = "The list of subnet IDs to launch the EKS cluster into"
  type        = list(string)
  
}

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