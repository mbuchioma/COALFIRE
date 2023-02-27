#VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "Demo-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "demo_IGW" {
  vpc_id = aws_vpc.demo_vpc.id

    tags = {
    Name = "demo-IGW"
  }
}

#Public Route
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo_vpc.id

    tags = {
    Name = "public-rtb1"
  }
}

#Public Route
resource "aws_route" "demo_public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo_IGW.id
  depends_on             = [aws_route_table.public]

  timeouts {
    create = var.create_timeout
  }
}

#Private Route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "private-rtb1"
  }
}

#Private  Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "private-Sub${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet" {  
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "public-Sub${count.index + 1}"
  }
}

#Public Routable Association
resource "aws_route_table_association" "pub_subnet_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

#Private Routable Association
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_route.id
}

#Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true
}

#NAT Gateway
resource "aws_nat_gateway" "demo_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name = "NatGateway01"
  }

  depends_on = [aws_internet_gateway.demo_IGW]
}


resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route.id
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.demo_nat.id
  timeouts {
    create = "5m"
  }
}