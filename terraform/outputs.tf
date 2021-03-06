# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "alb_hostname_frontend" {
  value = aws_alb.frontend.dns_name
}


