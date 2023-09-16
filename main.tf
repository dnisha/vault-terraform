locals {
  instance_type = "t2.micro"
}

resource "aws_instance" "public_ec2" {
  for_each                    = var.instance_map
  ami                         = each.value.ami
  instance_type               = local.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = each.value.key_name
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = each.value.associate_public_ip
  tags = {
    Name = each.key
    Tool = each.value.tool
  }
}
