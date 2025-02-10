output "cluster_name" {
  value = aws_eks_cluster.main.name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
  description = "EKS cluster endpoint"
  
}