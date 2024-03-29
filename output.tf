output "vpc_id" {
  value = aws_vpc.tf-vpc.id
}

output "subnet_1a_public_id" {
  value = aws_subnet.tf-1a-public.id
}

output "subnet_1a_private_id" {
  value = aws_subnet.tf-1a-private.id
}

output "subnet_1b_public_id" {
  value = aws_subnet.tf-1b-public.id
}

output "subnet_1b_private_id" {
  value = aws_subnet.tf-1b-private.id
}

output "tf_igw_id" {
  value = aws_internet_gateway.tf-igw.id
}

output "tf_nat_gw_id" {
  value = aws_nat_gateway.tf-nat-gw.id
}

output "tf_nat_ip" {
  value = aws_eip.tf-nat-ip.public_ip
}

output "tf-route-table-pub-id" {
  value = aws_route_table.tf-rtb-public.id
}

output "tf-route-table-private-id" {
  value = aws_route_table.tf-rtb-private.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eksCluster.arn
}

output "eksNodeRoleArn" {
  value = aws_iam_role.eksNodeRole.arn
}
output "eksAwsLoadBalancerControllerRoleArn" {
  value = aws_iam_role.eksAwsLoadBalancerController.arn
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

output "eksEC2JumpServerIP" {
  value = aws_instance.jump.public_ip
}

output "eksEC2JumpServer_ebs_id" {
  value = aws_instance.jump.root_block_device.0.volume_id
}
output "keypair_name" {
  value = aws_key_pair.jump_key.key_name
}
