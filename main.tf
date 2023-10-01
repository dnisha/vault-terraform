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

module "instance_iam" {
  source         = "git::https://github.com/dnisha/vault-terraform.git?ref=iam"
}

module "batian_instance" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.pub_security.sg_id
  subnet_id       = module.network.pub_subnet_id
  instance_map    = var.batian_instance_map
  instance_profile = module.instance_iam.bastian_role_name
}

module "vault_instance" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.priv_security.sg_id
  subnet_id       = module.network.priv_subnet_id
  instance_map    = var.vault_instance_map
  instance_profile = module.instance_iam.vault_role_name
}

module "console_instance_az1" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.priv_security.sg_id
  subnet_id       = module.network.console_subnet_id
  instance_map    = var.console_instance_az1
  instance_profile = module.instance_iam.console_role_name
}

module "console_instance_az2" {
  source          = "git::https://github.com/dnisha/vault-terraform.git?ref=ec2-module"
  security_groups = module.priv_security.sg_id
  subnet_id       = module.network.console_subnet_id2
  instance_map    = var.console_instance_az2
  instance_profile = module.instance_iam.console_role_name
}

module "alb_attach" {
  source = "git::https://github.com/dnisha/vault-terraform.git?ref=alb-module"
  vpc_id = module.network.ninja_vpc_id
  alb_subnet_list = module.network.pub_subnet_id_list
  vault_ami = "ami-0ae696fc0ea530f33"
  public_sg_list = module.pub_security.sg_id
  vault_instance = module.vault_instance.instance_object
  vault_sg_list = module.priv_security.sg_id
  vault_subnet_list = module.network.priv_subnet_id_list
}