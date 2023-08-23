# define security group
resource "aws_security_group" "allow-ssh" {
  vpc_id = aws_vpc.main.id
  description = "security group example"

  # inbound
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}