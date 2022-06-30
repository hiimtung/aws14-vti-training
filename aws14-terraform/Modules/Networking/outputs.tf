output "vpc" {
  value = module.vpc #Export values of vpc's module
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "sg" {
  value = module.ec2_sg.security_group.id #Export sg id for ec2s from ec2_sg's module
}