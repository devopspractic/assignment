provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}
module "bastion" {
  source = "./modules/Bastion"
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
  vpc_id = module.vpc.vpc_id
  source = "./modules/rds"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  name              = "database-1"
}
module "efs" {
  source = "./modules/efs"
  public_subnet_id = module.vpc.public_subnet
}
