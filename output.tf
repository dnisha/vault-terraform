output "instance_object" {
  description = "List of instance IDs"
  value = values(aws_instance.public_ec2)
}
