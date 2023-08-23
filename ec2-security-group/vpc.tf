resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # 적절한 CIDR 블록으로 변경해야 합니다.
  availability_zone       = "us-east-1a"   # 적절한 가용 영역으로 변경해야 합니다.
}

