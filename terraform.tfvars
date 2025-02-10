region = "ap-south-1"
// bucket_name = "terraform-eks-state-bucket-pavana"
// dynamodb_table_name = "terraform-eks-state-locks"
cluster_name = "my-eks-cluster"
cluster_version = "1.30"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
subnet_ids = ["subnet-12345678", "subnet-23456789"]
node_groups = [
  {
    name          = "node-group-1"
    instance_type = "t3.medium"
  }
]