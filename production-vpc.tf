

resource "aws_vpc" "production_vpc" {
  cidr_block           = var.production_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "production-vpc"
  }
}


# Private Subnet 1


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.production_subnet1_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "production-private-subnet-1"
  }
}

# Private Subnet 2

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.production_subnet2_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "production-private-subnet-2"
  }
}

# Private Subnet 3


resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.production_subnet3_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "production-private-subnet-3"
  }
}
# Private Route Table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production-private-rt"
  }
}

# Route Table Associations

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}

# PRODUCTION ROUTE TO NETWORK VIA TGW


resource "aws_route" "production_to_network" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = var.network_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}
# PRODUCTION TO INTERNET VIA NETWORK
resource "aws_route" "production_to_internet_via_network" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.main_tgw.id
}
