output "sg_id" {
  value = toset([aws_security_group.ninga_pub_sg.id])
}

output "nacl_id" {
  value = aws_network_acl.ninja_nacl.id
}

