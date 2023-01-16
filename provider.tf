provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}
module "bastion" {
  source = "./modules/bastion"
  ami =  var.ami
  instance_type = var.instance_type
  key = file("deployer.pub")
}
module "VPC" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  publicsubnet_cidr = var.publicsubnet_cidr
  privatesubnet_cidr = var.privatesubnet_cidr
}
module "EKS" {
  source = "./modules/eks"
}
module "rds" {
  source = "./modules/rds"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  name              = "database-1"
}
