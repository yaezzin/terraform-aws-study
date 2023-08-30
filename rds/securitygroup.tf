# security group for instance
resource "aws_security_group" "allow_ssh" {
  name        = "allows-ssh"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# security group for mysql
resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "MySQL from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    # ssh를 허용하는 인스턴스에게 mysql 서비스 액세스 권한 제공
    security_groups = [
        aws_security_group.allow_ssh.id
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}