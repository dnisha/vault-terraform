variable "vpc_id" {
  type    = string
  default = "vpc-0fc9060dc73840db8"
}

variable "alb_subnet_list" {
  type    = list(string)
  default = ["subnet-04dffad7706297237", "subnet-05b73760f13f91dca"]
}

variable "vault_subnet_list" {
  type    = list(string)
  default = ["subnet-04dffad7706297237", "subnet-05b73760f13f91dca"]
}

variable "vault_ami" {
  type    = string
  default = "ami-0b8323d51e0d7eff5"
}

variable "public_sg_list" {
  type    = list(string)
  default = ["sg-09decdb19debd6a3a"]
}

variable "vault_sg_list" {
  type    = list(string)
  default = ["sg-01c5e535d8683e4d7"]
}

variable "vault_instance" {
  type = list(object({
    id = string
  }))
  default = [{ id = "i-0538e011f57a5bb0b" }, { id = "i-060d23a0ee47bb050" }]
}