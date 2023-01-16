resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "RDS security group"
  vpc_id = modules.vpc.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  name              = var.name
  username          = var.username
  password          = var.password
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  subnet_ids = [modules.vpc.private_subnet]
}







resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks =["192.168.128.0/18, 192.168.192.0/1"]

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "shivam"
  password             = "shivam123"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
}
