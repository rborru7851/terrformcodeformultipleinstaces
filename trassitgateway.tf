provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"  # Replace with your desired CIDR block
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"  # Replace with your desired subnet CIDR block
}

resource "aws_ec2_transit_gateway" "example_transit_gateway" {
  description = "Example Transit Gateway"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example_attachment" {
  transit_gateway_id       = aws_ec2_transit_gateway.example_transit_gateway.id
  vpc_id                   = aws_vpc.example_vpc.id
  subnet_ids               = [aws_subnet.example_subnet.id]
  dns_support              = true
  ipv6_support             = false
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_route_table" "example_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.example_transit_gateway.id
}

resource "aws_ec2_transit_gateway_route_table_association" "example_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example_route_table.id
}
