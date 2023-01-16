resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = var.key_value
}
resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    # VPC
    subnet_id = aws_subnet.public_1.id
    # Security Group
    vpc_security_group_ids = aws_security_group.ssh-allowed.id
    # the Public SSH key
    key_name = aws_key_pair.deployer.id
   tags = {
     Name = "bastion"
}
