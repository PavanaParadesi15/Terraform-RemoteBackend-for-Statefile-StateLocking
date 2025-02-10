// -----------------------------------------------------------------------------
// MASTER NODE CREATION
// -----------------------------------------------------------------------------

// Create IAM role for the Cluster ( Control plane) 
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}


// Attach the required policies to the role
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


// Create EKS Cluster
// attach the IAM role created to the cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
// Execution of EKS cluster depends on the IAM role policy attachment
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

// -----------------------------------------------------------------------------
// NODE GROUP CREATION - WORKER NODES
// -----------------------------------------------------------------------------

// Create IAM role for the Node Group ( Worker nodes)
// The worker nodes will assume this role and are created as EC2 instances
// this policy allows EC2 instances to assume the IAM Role associated with the node group
// By granting the sts:AssumeRole action to EC2, you're allowing the EC2 instances to assume the role and access the resources that the role has permissions to access.
 
resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

// Attach the required policies to the role
// We are granting permissions such as EC2 Container Registry, EKS Worker Node Policy, and CNI Policy to the worker nodes
// The AmazonEKSWorkerNodePolicy policy grants the necessary permissions to register and deregister nodes with your Amazon EKS cluster.
// The AmazonEKS_CNI_Policy policy grants the necessary permissions to allow the worker nodes to communicate with the cluster control plane.
// The AmazonEC2ContainerRegistryReadOnly policy grants the necessary permissions to pull container images from Amazon ECR.

resource "aws_iam_role_policy_attachment" "node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.node.name
}


// Create EKS Node Group - EC2 Instance node group
// for_each loop: there will be multiple instances/worker nodes
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

// auto scaling configuration
  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

// worker node depends on the IAM role created for it
  depends_on = [
    aws_iam_role_policy_attachment.node_policy
  ]
}