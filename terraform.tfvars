region = "us-east-1"
ami = "ami-09e2d756e7d78558d"
instance_type = "t2.micro"
vpc_cidr =  "192.168.0.0/16"
publicsubnet_cidr = ["192.168.0.0/18", "192.168.64.0/18"]
privatesubnet_cidr = ["192.168.128.0/18", "192.168.192.0/18"]
