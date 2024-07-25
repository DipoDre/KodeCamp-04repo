# Create Subnet
resource "aws_subnet" "kc-public-subnet" {
  vpc_id            = var.vpc-id
  cidr_block        = var.subnet_cidr
  availability_zone = var.subnet-availability-zone

  tags = {
    Name    = "${var.tag_name}-public-subnet"
    Project = var.tag_name
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "kc-igw" {
  vpc_id = var.vpc-id

  tags = {
    Name    = "${var.tag_name}-igw"
    Project = var.tag_name
  }
}

# Create Route table
resource "aws_route_table" "PublicRouteTable" {
  vpc_id = var.vpc-id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kc-igw.id
  }

  tags = {
    Name    = "${var.tag_name}-public-route-table"
    Project = var.tag_name
  }
}

# Associate the route table to the subnet
resource "aws_route_table_association" "kc-public-rtb-association" {
  depends_on     = [aws_subnet.kc-public-subnet, aws_route_table.PublicRouteTable]
  subnet_id      = aws_subnet.kc-public-subnet.id
  route_table_id = aws_route_table.PublicRouteTable.id

}
