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

resource "aws_instance" "web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  
  # vpc subnet
  subnet_id               = aws_subnet.example.vpc_id
  
  # security group
  vpc_security_group_ids  = [
    aws_security_group.allow-ssh.id
  ]

  # public ssh key
  # ssh {public_ip} -l ubuntu -i mykey
  key_name = aws_key_pair.mykeypair.key_name
}