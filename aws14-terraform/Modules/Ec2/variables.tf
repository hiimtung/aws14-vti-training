variable "name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = any
}
variable "ec2_tags" {
  type = any
}
variable "key_name" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "iam_instance_profile" {
  type = string
}