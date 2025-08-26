# IAM Role for EKS Control Plane
resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-${var.environment}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-eks-role"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-${var.environment}-nodegroup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-nodegroup-role"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "${var.cluster_name}-${var.environment}"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids              = concat(aws_subnet.public[*].id, aws_subnet.private[*].id) # use both public and private subnets
    endpoint_private_access = true
    endpoint_public_access  = var.enable_public_access # toggle via variable
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn # optional, for secret encryption
    }
  }

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-eks"
    Environment = var.environment
    Terraform   = "true"
  }
}
