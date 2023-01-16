resource "aws_security_group" "efs-sg" {
  name        = "efs-sg"
  description = "Efs security group"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_efs_file_system" "cluster_efs" {
  creation_token = "cluster_efs"
}

resource "aws_efs_mount_target" "mount_efs" {
  file_system_id = aws_efs_file_system.cluster_efs.id
  subnet_id      = modules.vpc.public_subnet
  security_groups = [aws_security_group.example.id]
}

output "aws_efs_file_system"{
   value = aws_efs_file_system.mount_efs.id
}
