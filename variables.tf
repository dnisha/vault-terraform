variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "route_table" {
  type = map(object({
    type = string
  }))

  default = {
    "ninja-route-pub-01" = {
      type = "public"
    },
    "ninja-route-priv-01" = {
      type = "private"
    }
  }
}

variable "pub_subnet_map" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  default = {
    "ninja-pub-sub-01" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-south-1a"
    },
    "ninja-pub-sub-02" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}

variable "priv_subnet_map" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  default = {

    "ninja-priv-sub-01" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-south-1a"
    },
    "ninja-priv-sub-02" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-south-1b"
    },
    "ninja-priv-sub-03" = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-south-1a"
    },
    "ninja-priv-sub-04" = {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}

variable "batian_instance_map" {
  type = map(object({
    ami                 = string
    key_name            = string
    associate_public_ip = bool
    tool                = string
  }))

  default = {
    "instance-pub-sub-01" = {
      ami                 = "ami-0f5ee92e2d63afc18"
      key_name            = "gone-servers"
      associate_public_ip = true
      tool                = "batian"
    }
  }
}

variable "private_instance_map" {
  type = map(object({
    ami                 = string
    key_name            = string
    associate_public_ip = bool
    tool                = string
  }))

  default = {
    "instance-priv-sub-01" = {
      ami                 = "ami-0f5ee92e2d63afc18"
      key_name            = "gone-servers"
      associate_public_ip = false
      tool                = "vault"
    },
    "instance-priv-sub-02" = {
      ami                 = "ami-0f5ee92e2d63afc18"
      key_name            = "gone-servers"
      associate_public_ip = false
      tool                = "vault"
    }
  }
}

variable "pub_ninja_sg" {
  type = object({
    name = string

    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)

    }))

    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)

    }))

  })

  default = {
    name = "ninga_pub_sg"

    ingress = [
      {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/24"]
    }]

    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/24"]
      }
    ]
  }
}

variable "priv_ninja_sg" {
  type = object({
    name = string

    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)

    }))

    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)

    }))

  })

  default = {
    name = "ninga_priv_sg"

    ingress = [
      {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/24"]
    }]

    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/24"]
    }]
  }
}

variable "pub_nacl_rules" {
  type = list(object({
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    egress      = bool
  }))

  default = [
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 65535
      egress      = false
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/24"
      from_port   = 22
      to_port     = 22
      egress      = false
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 65535
      egress      = true
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/24"
      from_port   = 1024
      to_port     = 65535
      egress      = true
    }
  ]
}

variable "priv_nacl_rules" {
  type = list(object({
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    egress      = bool
  }))

  default = [
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/24"
      from_port   = 22
      to_port     = 22
      egress      = false
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 65535
      egress      = false
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 1024
      to_port     = 65535
      egress      = true
    },
    {
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 65535
      egress      = true
    }
  ]
}