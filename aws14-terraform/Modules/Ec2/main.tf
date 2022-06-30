#Create launch template from ami
data "aws_ami" "ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  owners = ["137112412989"]
}
module "ec2-instance" {
  for_each                    = toset(var.ec2_tags)
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.0.0"
  ami                         = data.aws_ami.ami.id
  name                        = "${var.name}${each.key}"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true
  key_name                    = var.key_name
  monitoring                  = true
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = filebase64("${path.module}/userdata.sh")
}