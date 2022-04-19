variable "eks_jump_pubkey" {
  type = string
}
resource "aws_key_pair" "jump_key" {
  key_name   = "eks-jump-key"
  public_key = var.eks_jump_pubkey
}
