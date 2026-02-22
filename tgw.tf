
# TRANSIT GATEWAY


resource "aws_ec2_transit_gateway" "main_tgw" {
  description = "enterprise-transit-gateway"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "transit-gateway"
  }
}

# NETWORK VPC ATTACHMENT


resource "aws_ec2_transit_gateway_vpc_attachment" "network_attachment" {
  subnet_ids         = [aws_subnet.network_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.network_vpc.id

  tags = {
    Name = "network-tgw-attachment"
  }
}

# PRODUCTION VPC ATTACHMENT


resource "aws_ec2_transit_gateway_vpc_attachment" "production_attachment" {
  subnet_ids = [ aws_subnet.private_subnet_1.id]
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id             = aws_vpc.production_vpc.id

  tags = {
    Name = "production-tgw-attachment"
  }
}

# TGW ROUTE TABLE


resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id

  tags = {
    Name = "tgw-route-table"
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "network_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.network_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "prod_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.production_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

# TGW ROUTES


resource "aws_ec2_transit_gateway_route" "to_production" {
  destination_cidr_block         = var.production_vpc_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.production_attachment.id
}

resource "aws_ec2_transit_gateway_route" "to_network" {
  destination_cidr_block         = var.network_vpc_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.network_attachment.id
}

