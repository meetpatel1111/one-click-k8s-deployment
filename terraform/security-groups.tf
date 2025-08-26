# Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-${var.environment}-eks-nodes-sg"
  vpc_id      = aws_vpc.main.id
  description = "EKS worker nodes security group for ${var.environment} environment"

  # Allow worker nodes to communicate with EKS API (control plane)
  ingress {
    description     = "Allow EKS API access from cluster"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  # Node-to-node communication (pods)
  ingress {
    description = "Node-to-node communication within SG"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # Optional: SSH from Internet
  ingress {
    description = "SSH access from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic (can be restricted further if needed)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-eks-nodes"
    Environment = var.environment
    Terraform   = "true"
  }
}
