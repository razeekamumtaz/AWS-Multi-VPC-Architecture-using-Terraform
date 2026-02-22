# NETWORK VPC 

resource "aws_vpc" "network_vpc" {
  cidr_block           = var.network_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "network-vpc"
  }
}

# PUBLIC SUBNET (For LB + NAT)


resource "aws_subnet" "network_public_subnet" {
  vpc_id                  = aws_vpc.network_vpc.id
  cidr_block              = var.network_public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "network-public-subnet"
  }
}

# PRIVATE SUBNET


resource "aws_subnet" "network_private_subnet" {
  vpc_id            = aws_vpc.network_vpc.id
  cidr_block        = var.network_private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "network-private-subnet"
  }
}


# INTERNET GATEWAY

resource "aws_internet_gateway" "network_igw" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    Name = "network-igw"
  }
}


# ELASTIC IP FOR NAT

resource "aws_eip" "network_nat_eip" {
  domain = "vpc"
}


# NAT GATEWAY (Placed in Public Subnet)

resource "aws_nat_gateway" "network_nat" {
  allocation_id = aws_eip.network_nat_eip.id
  subnet_id     = aws_subnet.network_public_subnet.id

  tags = {
    Name = "network-nat"
  }

  depends_on = [aws_internet_gateway.network_igw]
}


# PUBLIC ROUTE TABLE


resource "aws_route_table" "network_public_rt" {
  vpc_id = aws_vpc.network_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network_igw.id
  }

  tags = {
    Name = "network-public-rt"
  }
}

resource "aws_route_table_association" "network_public_assoc" {
  subnet_id      = aws_subnet.network_public_subnet.id
  route_table_id = aws_route_table.network_public_rt.id
}


# PRIVATE ROUTE TABLE


resource "aws_route_table" "network_private_rt" {
  vpc_id = aws_vpc.network_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.network_nat.id
  }

  tags = {
    Name = "network-private-rt"
  }
}

resource "aws_route_table_association" "network_private_assoc" {
  subnet_id      = aws_subnet.network_private_subnet.id
  route_table_id = aws_route_table.network_private_rt.id
}

# NETWORK ROUTE TO PRODUCTION VIA TGW


resource "aws_route" "network_to_production" {
  route_table_id         = aws_route_table.network_private_rt.id
  destination_cidr_block = var.production_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}
