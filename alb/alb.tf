resource "aws_lb" "example" {
  name                       = "alb-example"
  internal                   = false
  load_balancer_type         = "application" # ALB의 경우 application, NLB의 경우 network 설정
  enable_deletion_protection = true

  # 보안 그룹 설정
  security_groups    = [
    aws_security_group.alb.id
  ]

  # 서브넷 설정 
  subnets = aws_subnet.example[*].id
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_target_group" "example" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "example" {
  # aws_lb_target_group_attachment 
  # - ALB에서 타겟 그룹과 EC2 인스턴스를 연결하는데 사용
  # - 따라서 어떤 EC2 인스턴스가 ALB의 로드 밸런싱 대상이 되는지 정의할 수 있음
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.example.id
}