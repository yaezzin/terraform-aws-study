data "aws_ip_ranges" "ap-northeast-2" {
  regions = [ "ap-northeast-2" ]
  services = [ "ec2" ]
}

# 특정 리전에 속하는 public IP에 대한 443 허용
resource "aws_security_group" "north-east" {
  name = "northeast-2"

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = [ "${data.aws_ip_ranges.ap-northeast-2.cidr_blocks}" ]
  }

  tags = {
    CreateDate = "${data.aws_ip_ranges.ap-northeast-2.create+date}"
    SyncToken = "${data.aws_ip_ranges.ap-northeast-2.sync_token}"
  }
}

# 모든 리전의 public IP 허용
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