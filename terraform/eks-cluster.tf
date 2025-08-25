resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config { subnet_ids = aws_subnet.private[*].id }
  enabled_cluster_log_types = ["api","audit","authenticator"]
}
