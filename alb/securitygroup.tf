# 3-1. create security group for EC2
resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id
  description = "security group for EC2"

  # inbound
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # inbound
  ingress {
      protocol  = "tcp"
      from_port = 8080
      to_port   = 8080
      cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3-2. create security group for ALB
resource "aws_security_group" "alb" {
  name = "terraform-example-alb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}