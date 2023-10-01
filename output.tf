# output "ninja_vpc_id" {
#   value = module.network.ninja_vpc_id
# }

# output "pub_subnet_id" {
#   value = module.network.pub_subnet_id
# }

# output "priv_subnet_id" {
#   value = module.network.priv_subnet_id
# }

# output "pub_sg_id" {
#   value = module.pub_security.sg_id
# }

output "alb_dns" {
  value = module.alb_attach.lb_dns
}

output "batian_instance_ip" {
  value = module.batian_instance.instance_object[0].public_ip
}