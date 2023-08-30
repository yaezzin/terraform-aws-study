# DNS : 도메인 이름과 IP 주소 사이의 매핑을 담당

resource "aws_instance" "main" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
}

resource "aws_eip" "lb" {
  instance = aws_instance.main.id
  domain   = "vpc"
}

# domain 생성
resource "aws_route53_zone" "new-domain" {
  name = "new-domain" 
}

# 호스트 네임에 대한 DNS 레코드를 생성
resource "aws_route53_record" "server1-record" {
  zone_id = aws_route53_zone.new-domain.zone_id
  name    = "server1.example.com"
  type    = "A" # A 레코드는 호스트 네임을 IPv4 주소로 매핑
  ttl     = 300
  records = [aws_eip.lb.public_ip]
}

