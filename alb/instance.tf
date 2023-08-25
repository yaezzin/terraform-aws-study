# 2. create EC2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "example" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.example.vpc_id
  vpc_security_group_ids  = [
    aws_security_group.instance.id
  ]
}