output "lb_dns" {
  value = aws_lb.vault_lb.dns_name
}