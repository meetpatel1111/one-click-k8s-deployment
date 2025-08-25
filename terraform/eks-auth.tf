# Fetch EKS cluster details
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

# Generate short-lived authentication token
data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}