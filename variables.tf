variable "ami" {
  type = string

}

variable "instance_type" {
  type = string

}
variable "vpc_cidr" {
  type        = string
  description = "CIDR range for the vpc"
}

variable "publicsubnet_cidr" {
  type        = list
  description = "CIDR range for the public subnet"
}

variable "privatesubnet_cidr" {
  type        = list
  description = "CIDR range for the private subnet"
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "region" {
   type = string
}
