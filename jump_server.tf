resource "aws_eip" "tf-eks-ec2-jump-ip" {
  vpc = true
  tags = {
    Name = "tf-eks-ec2-jump-ip"
  }
  instance = aws_instance.eksjump.id
}

resource "aws_instance" "eksjump" {
  ami                    = "ami-055d15d9cfddf7bd3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf-1a-public.id
  vpc_security_group_ids = [aws_security_group.eksEC2JumpSg.id]
  tags = {
    Name = "tf-eks-ec2-jump"
  }
  key_name = aws_key_pair.jump_key.key_name
  root_block_device {
    tags        = local.common_tags
    volume_size = 10
    volume_type = "gp3"
  }
}

# resource "aws_instance" "eksjump2" {
#   ami                    = "ami-055d15d9cfddf7bd3"
#   instance_type          = "t3.micro"
#   subnet_id              = aws_subnet.tf-1a-public.id
#   vpc_security_group_ids = [aws_security_group.eksEC2JumpSg.id]
#   tags = {
#     Name = "tf-eks-ec2-jump2"
#   }
#   key_name = aws_key_pair.jump_key.key_name
#   root_block_device {
#     tags        = local.common_tags
#     volume_size = 10
#     volume_type = "gp3"
#   }
#   user_data = filebase64("./jump_ec2_script.sh")
# }



