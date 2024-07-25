resource "aws_vpc" "kc-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name    = "${var.tag_name}-vpc"
    Project = var.tag_name
  }
}
