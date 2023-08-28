resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  
  availability_zone       = "ap-northeast-1"
}

