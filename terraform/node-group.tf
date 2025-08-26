resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-${var.environment}-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = aws_subnet.private[*].id  # Only private subnets for better security

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = [var.node_instance_type]

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-nodegroup"
    Environment = var.environment
    Terraform   = "true"
  }

  # Optional: Enable remote access via SSH only if needed, otherwise omit
  # remote_access {
  #   ec2_ssh_key = var.ssh_key_name
  #   source_security_group_ids = [aws_security_group.eks_nodes.id]
  # }

  # Optional: Labels for node grouping and workload identification
  labels = {
    environment = var.environment
    role        = "worker"
  }

  # Optional: Taints to isolate workloads
  # taints = [
  #   {
  #     key    = "dedicated"
  #     value  = "gpu"
  #     effect = "NO_SCHEDULE"
  #   }
  # ]
}
