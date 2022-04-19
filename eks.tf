resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = ["api",
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

output "cluster-name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster-sg" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

output "ca" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "oidc" {
  value = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
