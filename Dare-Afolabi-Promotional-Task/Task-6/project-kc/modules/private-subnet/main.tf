# Create Subnet
resource "aws_subnet" "kc-private-subnet" {
  vpc_id            = var.vpc-id
  cidr_block        = var.subnet_cidr
  availability_zone = var.subnet-availability-zone

  tags = {
    Name    = "${var.tag_name}-private-subnet"
    Project = var.tag_name
  }
}

# Create Elastic IP
resource "aws_eip" "kc_eip" {
  domain = "vpc"

  tags = {
    Name    = "${var.tag_name}-eip"
    Project = var.tag_name
  }
}

# Create NAT gateway
resource "aws_nat_gateway" "kc-nat" {
  depends_on    = [aws_eip.kc_eip]
  allocation_id = aws_eip.kc_eip.id
  subnet_id     = var.public-subnet-id

  tags = {
    Name    = "${var.tag_name}-nat"
    Project = var.tag_name
  }
}

# Create Route table
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id     = var.vpc-id
  depends_on = [aws_nat_gateway.kc-nat]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.kc-nat.id
  }

  tags = {
    Name    = "${var.tag_name}-private-route-table"
    Project = var.tag_name
  }
}

# Associate the route table to the subnet
resource "aws_route_table_association" "kc-private-rtb-association" {
  depends_on     = [aws_subnet.kc-private-subnet, aws_route_table.PrivateRouteTable]
  subnet_id      = aws_subnet.kc-private-subnet.id
  route_table_id = aws_route_table.PrivateRouteTable.id

}




