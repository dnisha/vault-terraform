resource "aws_eip" "ninja_eip" {}

resource "aws_vpc" "ninja_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ninja-vpc-01"
  }
}

resource "aws_internet_gateway" "ninja_igw" {
  vpc_id = aws_vpc.ninja_vpc.id

  tags = {
    Name = "ninja-igw"
  }
}

resource "aws_nat_gateway" "ninja_nat_gateway" {

  for_each = {
    for key, value in aws_subnet.pub_ninja_subnet :
    key => value
    if key == "ninja-pub-sub-01"
  }
  allocation_id = aws_eip.ninja_eip.id
  subnet_id     = aws_subnet.pub_ninja_subnet[each.key].id
}

resource "aws_subnet" "pub_ninja_subnet" {
  for_each          = var.pub_subnet_map
  vpc_id            = aws_vpc.ninja_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "priv_ninja_subnet" {
  for_each          = var.priv_subnet_map
  vpc_id            = aws_vpc.ninja_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "pub_ninja_rt" {
  vpc_id = aws_vpc.ninja_vpc.id

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "priv_ninja_rt" {
  vpc_id = aws_vpc.ninja_vpc.id

  tags = {
    Name = "private"
  }
}

resource "aws_route" "subnet_public_route" {
  route_table_id         = aws_route_table.pub_ninja_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ninja_igw.id
}

resource "aws_route" "subnet_private_route" {
  for_each               = aws_nat_gateway.ninja_nat_gateway
  route_table_id         = aws_route_table.priv_ninja_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ninja_nat_gateway[each.key].id
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each       = aws_subnet.pub_ninja_subnet
  subnet_id      = aws_subnet.pub_ninja_subnet[each.key].id
  route_table_id = aws_route_table.pub_ninja_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each       = aws_subnet.priv_ninja_subnet
  subnet_id      = aws_subnet.priv_ninja_subnet[each.key].id
  route_table_id = aws_route_table.priv_ninja_rt.id
}
