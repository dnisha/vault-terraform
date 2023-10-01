output "bastian_role_name" {
  value = aws_iam_instance_profile.bastian_profile.name
}

output "vault_role_name" {
  value = aws_iam_instance_profile.vault_profile.name
}

output "console_role_name" {
  value = aws_iam_instance_profile.console_profile.name
}