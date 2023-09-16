variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
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
    }


  }
}

variable "pub_route_table" {
  type = map(object({
    type = string
  }))

  default = {
    "ninja-route-pub-01" = {
      type = "public"
    },
    "ninja-route-pub-02" = {
      type = "private"
    }
  }
}

variable "priv_route_table" {
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
