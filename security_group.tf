resource "aws_security_group" "eksClusterSg" {
  name        = "eksClusterSg"
  description = "allow node eks traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eksEC2JumpSg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Security group for Jump server
resource "aws_security_group" "eksEC2JumpSg" {
  name        = "eksEC2JumpSg"
  description = "allow all traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

