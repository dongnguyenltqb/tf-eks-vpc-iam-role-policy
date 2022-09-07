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
      aws_security_group.cluster.id
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

resource "aws_security_group" "cluster" {
  depends_on = [
    aws_security_group.jump
  ]
  name        = format("%sEKSClusterSg", var.cluster_name)
  description = "Security group for cluster"
  vpc_id      = aws_vpc.tf-vpc.id

  // allow all traffic from jump server
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jump.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



