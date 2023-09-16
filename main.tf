resource "aws_security_group" "ninga_pub_sg" {
  name        = var.security_group.name
  description = "Security group for ${var.security_group.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.security_group.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_network_acl" "ninja_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_id_list
  tags = {
    Name = "ninja-NACL"
  }
}

resource "aws_network_acl_rule" "allow_ports" {
  count = length(var.nacl_rules)

  rule_number    = 100 + count.index
  protocol       = var.nacl_rules[count.index].protocol
  rule_action    = var.nacl_rules[count.index].rule_action
  cidr_block     = var.nacl_rules[count.index].cidr_block
  from_port      = var.nacl_rules[count.index].from_port
  to_port        = var.nacl_rules[count.index].to_port
  network_acl_id = aws_network_acl.ninja_nacl.id
  egress         = var.nacl_rules[count.index].egress
}