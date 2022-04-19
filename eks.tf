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

resource "aws_eks_node_group" "t3small" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "t3small"
  disk_size       = 20
  instance_types  = ["t3.small"]
  labels          = local.common_tags
  tags            = local.common_tags
  node_role_arn   = aws_iam_role.eksNodeRole.arn
  ami_type        = "AL2_x86_64"
  subnet_ids = [
    aws_subnet.tf-1a-public.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksNodeRole_AmazonEKS_CNI_Policy_attachment,
    aws_iam_role_policy_attachment.eksNodeRole_AmazonEC2ContainerRegistryReadOnlyPolicy_attachment
  ]
}

output "cluster-name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster-sg" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "oidc" {
  value = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
