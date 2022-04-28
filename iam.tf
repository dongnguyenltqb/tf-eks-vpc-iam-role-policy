// Provides Kubernetes the permissions it requires to manage resources on your behalf
resource "aws_iam_role" "eksClusterRole" {
  name = "tfEKSClusterRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eksClusterRole_AmazonEKSClusterPolicy_attachment" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

// Allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
// Provides read-only access to Amazon EC2 Container Registry repositories.
// Provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes
resource "aws_iam_role" "eksNodeRole" {
  name = "tfEKSNodeRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEKSWorkerNodePolicy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEC2ContainerRegistryReadOnlyPolicy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEKS_CNI_Policy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eksCluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

// Provide permission for AWS load balancer controller pod
// to create ingress 
resource "aws_iam_role" "eksAwsLoadBalancerController" {
  name               = "aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.eksAwsLoadBalancerControllerPolicyDocument.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "eksAwsLoadBalancerControllerPolicy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  role = aws_iam_role.eksAwsLoadBalancerController.id

  policy = file("aws-load-balancer-controller-policy.json")
}

data "aws_iam_policy_document" "eksAwsLoadBalancerControllerPolicyDocument" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksCluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksCluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksCluster.arn]
      type        = "Federated"
    }
  }
}
