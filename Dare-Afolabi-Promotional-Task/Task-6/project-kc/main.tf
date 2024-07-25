provider "aws" {
  region     = var.project_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create VPC
module "kc_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.project_vpc_cidr
  tag_name = var.project_tag_name
}


# Create public subnet
module "kc_PublicSubnet" {
  source                   = "./modules/public-subnet"
  vpc-id                   = module.kc_vpc.vpc-id
  subnet_cidr              = var.public_cidr
  subnet-availability-zone = var.project_az
  tag_name                 = var.project_tag_name
}

# Create private subnet
module "kc_PrivateSubnet" {
  source                   = "./modules/private-subnet"
  vpc-id                   = module.kc_vpc.vpc-id
  public-subnet-id         = module.kc_PublicSubnet.public-subnet-id
  subnet_cidr              = var.private_cidr
  subnet-availability-zone = var.project_az
  tag_name                 = var.project_tag_name
}

# Create public ec2 instance
module "kc_public_server" {
  source    = "./modules/public-ec2"
  ami-id    = var.ami
  ec2-type  = var.instance_type
  subnet-id = module.kc_PublicSubnet.public-subnet-id
  aws-key   = var.aws_key
  vpc-id    = module.kc_vpc.vpc-id
  tag_name  = var.project_tag_name
}

# Create private ec2 instance
module "kc_private_server" {
  source    = "./modules/private-ec2"
  ami-id    = var.ami
  ec2-type  = var.instance_type
  subnet-id = module.kc_PrivateSubnet.private-subnet-id
  aws-key   = var.aws_key
  vpc-id    = module.kc_vpc.vpc-id
  tag_name  = var.project_tag_name
}
