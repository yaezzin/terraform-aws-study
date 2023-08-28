resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  
  tags = {
    Name = "example"
  }
}

# subnets - 3 public, 1 private
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"  
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-northeast-1b"
}

resource "aws_subnet" "main-public-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true" 
  availability_zone       = "ap-northeast-1c"
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  
  map_public_ip_on_launch = "false" # private subnet은 public ip를 매핑하지 않음
  availability_zone       = "ap-northeast-1"
}

# Internet GW
# VPC 내의 퍼블릭 서브넷과 외부 인터넷 간의 연결을 제공
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# route table
# VPC 내의 트래픽을 어떻게 라우팅할지를 정의
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  # 0.0.0.0/0 (모든 대상)로 가는 트래픽을 aws_internet_gateway.main-gw로 라우팅
  # 퍼블릭 서브넷의 EC2 인스턴스가 외부로 나가는 트래픽을 인터넷 게이트웨이를 통해 라우팅
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "example"
  }
}

# route table association
# 서브넷이 어떤 라우팅 테이블을 사용할지를 정의
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id 
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.main-public-2.id 
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = aws_subnet.main-public-2.id 
  route_table_id = aws_route_table.main-public.id
}

