#  Create an ec2 instance
resource "aws_instance" "kc-private-ec2" {
  ami           = var.ami-id
  instance_type = var.ec2-type
  subnet_id     = var.subnet-id
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3"
  }
  tags = {
    Name    = "${var.tag_name}-private-ec2"
    Project = var.tag_name
  }
  key_name               = var.aws-key
  vpc_security_group_ids = [aws_security_group.kc-private-sg.id]
}

# Create a Private security group
resource "aws_security_group" "kc-private-sg" {
  vpc_id = var.vpc-id

  tags = {
    Name    = "${var.tag_name}-private-sg"
    Project = var.tag_name
  }
}

# Create security group rules
resource "aws_vpc_security_group_ingress_rule" "ssh-private" {
  security_group_id = aws_security_group.kc-private-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow-all-from-kc-public" {
  security_group_id = aws_security_group.kc-private-sg.id
  cidr_ipv4         = "10.0.1.0/24"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow-all-traffic-private" {
  security_group_id = aws_security_group.kc-private-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
