variable "aws_region" {
  default  = "ap-southeast-1"
  nullable = false
}

variable "base_cidr_block" {
  description = "A /16 CIDR range definition, such as 10.1.0.0/16, that the VPC will use, this vpc will has v^(32-16) =  2^16 IP address"
  default     = "10.1.0.0/16"
  nullable    = false
}

variable "cluster_name" {
  type = string
}
