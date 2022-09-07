variable "aws_region" {
  default  = "ap-southeast-1"
  nullable = false
}

variable "base_cidr_block" {
  default  = "10.1.0.0/16"
  nullable = false
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}

variable "jump_pubkey" {
  type = string
}
