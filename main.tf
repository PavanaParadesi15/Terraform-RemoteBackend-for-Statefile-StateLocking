// Backend configuration - we are using S3 bucket as backend configuration to store state file 
// and DynamoDB table to lock the state file to avoid concurrent modifications
// This is a best practice to store the state file in a centralized location

// Provider block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

// Backend configuration
  backend "s3" {
    bucket         = var.bucket_name
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = var.dynamodb_table_name
    encrypt        = true
  }
}

# Provider block
provider "aws" {
  region = var.region
}

// Module block - Invoke the modules
// VPC module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

// EKS module
module "eks" {
  source = "./modules/eks"

  region = var.region
  cluster_name    = "${var.cluster_name}-cluster-role"
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}