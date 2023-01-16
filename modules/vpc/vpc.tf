
#VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = false

  tags{
   Name = "main"
  }
}

output "vpc_id" {
 value = aws_vpc.main.id
 sensitive = false
}

#subnets  Configuration

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.publicsubnet_cidr[0]
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "public-us-east-1a"
     "kubernetes.io/cluster/eks" = "shared" //it allows eks cluster to discover this particular subnet and use it.
     " kubernetes.io/role/elb" = 1 //if we want to create a service of type load balancer then this tag is use to discover this subnet and associate LB with subnets.
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.publicsubnet_cidr[1]
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "public-us-east-1b"
     "kubernetes.io/cluster/eks" = "shared" //it allows eks cluster to discover this particular subnet and use it.
     " kubernetes.io/role/elb" = 1 //if we want to create a service of type load balancer then this tag is use to discover this subnet and associate LB with subnets.
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.privatesubnet_cidr[0]
  availability_zone = "us-east-1a"

  tags {
    Name = "private-us-east-1a"
     "kubernetes.io/cluster/eks" = "shared" //it allows eks cluster to discover this particular subnet and use it.
     " kubernetes.io/role/internal-elb" = 1 //for deployig private LBs
  }
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.privatesubnet_cidr[1]
  availability_zone = "us-east-1b"

  tags {
    Name                                =  "private-us-east-1b"
     "kubernetes.io/cluster/eks"        = "shared" //it allows eks cluster to discover this particular subnet and use it.
     " kubernetes.io/role/internal-elb" = 1 //for deployig private LBs
  }
}

#creating internet gateway to get internet connection

resource "aws_internet_gateway" "ig_main"{
   vpc_id = aws_vpc.main.id

   tags{
    Name = "main-ig"
   }
}

# Creating Elastic IPs for NAT Gateway

resource "aws_eip" "nat1"{
 depends_on = [aws_internet_gateway.main]
}
resource "aws_eip" "nat2"{
 depends_on = [aws_internet_gateway.main]
}

#creating NAT Gateway so that pods running in private subnet can access internet.
resource "aws_nat_gateway" "gwt1"{
  allocation_id = aws_eip.nat1.id
  subnet = aws_subnet.public_1.id

  tags{
    Name = "NAT 1"
  }
 }
 resource "aws_nat_gateway" "gwt2"{
   allocation_id = aws_eip.nat2.id
   subnet = aws_subnet.public_2.id

   tags{
     Name = "NAT 2"
   }
  }
#security group for cluster
  resource "aws_security_group" "ssh-allowed" {
      vpc_id = aws_vpc.main.id

      egress {
          from_port = 0
          to_port = 0
          protocol = -1
          cidr_blocks = ["0.0.0.0/0"]
  }
      ingress {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
      tags = {
          Name = "ssh-allowed"
      }
  }
