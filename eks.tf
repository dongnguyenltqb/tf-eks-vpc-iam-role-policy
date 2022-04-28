resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  name     = var.cluster_name
  role_arn = aws_iam_role.eksClusterRole.arn
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs = [
      "0.0.0.0/0",
    ]
    security_group_ids = [
      aws_security_group.eksClusterSg.id
    ]
    subnet_ids = [
      aws_subnet.tf-1a-public.id,
      aws_subnet.tf-1a-private.id,
      aws_subnet.tf-1b-public.id,
      aws_subnet.tf-1b-private.id,
      aws_subnet.tf-1c-public.id,
      aws_subnet.tf-1c-private.id,
    ]
  }
}

