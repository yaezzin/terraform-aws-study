output "ns-servers" {
  value = aws_route53_zone.new-domain.name_servers
}