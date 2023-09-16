module "network" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=network-module"
  vpc_cidr        = var.vpc_cidr
  pub_subnet_map  = var.pub_subnet_map
  priv_subnet_map = var.priv_subnet_map
}

module "pub_security" {
  source         = "git::https://github.com/dnisha/vault-terraform.git?ref=security-module"
  vpc_id         = module.network.ninja_vpc_id
  nacl_rules     = var.pub_nacl_rules
  security_group = var.pub_ninja_sg
  subnet_id_list = module.network.pub_subnet_id_list
}

module "priv_security" {
  source         = "git::https://github.com/dnisha/vault-terraform.git?ref=security-module"
  vpc_id         = module.network.ninja_vpc_id
  nacl_rules     = var.priv_nacl_rules
  security_group = var.priv_ninja_sg
  subnet_id_list = module.network.priv_subnet_id_list
}

module "batian_instance" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.pub_security.sg_id
  subnet_id       = module.network.pub_subnet_id
  instance_map    = var.batian_instance_map
}

module "private_instance" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.priv_security.sg_id
  subnet_id       = module.network.priv_subnet_id
  instance_map    = var.private_instance_map
}

