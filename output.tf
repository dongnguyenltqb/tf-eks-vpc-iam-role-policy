output "vpc_id" {
  value       = aws_vpc.tf-vpc.id
}

output "subnet_1a_public_id" {
  value       = aws_subnet.tf-1a-public.id
}

output "subnet_1a_private_id" {
  value       = aws_subnet.tf-1a-private.id
}

output "subnet_1b_public_id" {
  value       = aws_subnet.tf-1b-public.id
}

output "subnet_1b_private_id" {
  value       = aws_subnet.tf-1b-private.id
}

output "tf_igw_id" {
  value  = aws_internet_gateway.tf-igw.id
}

output "tf_nat_gw_id" {
  value  = aws_nat_gateway.tf-nat-gw.id
}

output "tf-route-table-pub-id" {
  value  = aws_route_table.tf-rtb-public.id
}

output "tf-route-table-private-id" {
  value  = aws_route_table.tf-rtb-private.id
}
