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
