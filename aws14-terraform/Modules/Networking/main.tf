#Create VPC from terraform's modules
data "aws_availability_zones" "available" {
  state = "available"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  name = var.name
  cidr = var.vpc_cidr
  azs = data.aws_availability_zones.available.names
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}
#Create security group for ec2s
module "ec2_sg" {
  source  = "terraform-in-action/sg/aws"
  name = "${var.name}-sg"
  version = "0.1.0"
  vpc_id = module.vpc.vpc_id
  ingress_rules = var.ingress_rules                         #Allow all traffic to http from anywhere 
}