variable "allocated_storage" {
  type = number
}
variable "storage_type" {
  type = string
}
variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "name" {
  type = string
}
variable "username" {
  type = string
  default = "Shivamkaushal"
}
variable "password" {
  type = string
  default = "shivam@123"
}
