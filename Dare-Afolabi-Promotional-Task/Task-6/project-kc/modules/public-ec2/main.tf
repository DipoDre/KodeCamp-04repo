#  Create an ec2 instance
resource "aws_instance" "kc-public-ec2" {
  ami                         = var.ami-id
  associate_public_ip_address = true
  instance_type               = var.ec2-type
  subnet_id                   = var.subnet-id
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3"
  }
  tags = {
    Name    = "${var.tag_name}-public-ec2"
    Project = var.tag_name
  }
  key_name               = var.aws-key
  vpc_security_group_ids = [aws_security_group.kc-public-sg.id]
  user_data              = file("nginx_pgsql_setup.sh")
}

# Create a Public security group
resource "aws_security_group" "kc-public-sg" {
  vpc_id = var.vpc-id

  tags = {
    Name    = "${var.tag_name}-public-sg"
    Project = var.tag_name
  }
}

# Create security group rules
resource "aws_vpc_security_group_ingress_rule" "ssh-public" {
  security_group_id = aws_security_group.kc-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http-public" {
  security_group_id = aws_security_group.kc-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https-public" {
  security_group_id = aws_security_group.kc-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "postgres-public" {
  security_group_id = aws_security_group.kc-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow-all-traffic-public" {
  security_group_id = aws_security_group.kc-public-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
