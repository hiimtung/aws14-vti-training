provider "aws" {
  region = "ap-southeast-1" #Change region here
  # profile = "tf"
}
#Create VPC
module "networking" {
  source         = "./Modules/Networking"
  name           = "AWS14-VPCX"                                        #Change name of VPC here
  vpc_cidr       = "172.16.0.0/16"                                     #Change cidr here
  public_subnets = ["172.16.2.0/23", "172.16.4.0/23", "172.16.6.0/23"] #Change ip ranges of public subnets here
  #[0]             [1]                [2]
  private_subnets = ["172.16.10.0/23", "172.16.12.0/23", "172.16.14.0/23"] #Change ip ranges of private subnets here

  #A new Security Group will be created, edit Inbound rules here
  ingress_rules = [ #Allow all traffic to http from anywhere
    {
      protocol    = "tcp"
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp" #Allow ssh from anywhere
      port        = 22
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["0.0.0.0/0"] #Allow ping from anywhere
    }
  ]

}
#Create public Ec2
module "instance-public" {
  source                 = "./Modules/Ec2"
  ec2_tags               = ["1", "2"]                          #Number of public ec2s to create
  name                   = "aws14-public-"                     #Change name here
  instance_type          = "t2.micro"                          #Change instance type here
  subnet_id              = module.networking.public_subnets[0] #Change index [0] to [1],[2],... to select other public ranges 
  vpc_security_group_ids = [module.networking.sg]              #Security group to associated with
  iam_instance_profile   = ""                                  #Change iam role here
  key_name               = "vti-academy-aws14"                 #Change key pair here
}
#To create other Ec2s in another az or subnet, copy the module above, rename the new module and edit the index [] of subnet_id
# then Reinit by terraform init to make changes


#Comment all below if you only want to create public ec2s
#Create private Ec2
module "instance2-private" {
  source                 = "./Modules/Ec2"
  ec2_tags               = ["1"]                                #Number of private ec2s to create
  name                   = "aws14-private-"                     #Change name here
  instance_type          = "t2.micro"                           #Change instance type here
  subnet_id              = module.networking.private_subnets[0] #Change index [0] to [1],[2],... to select other public ranges
  vpc_security_group_ids = [module.networking.sg]
  iam_instance_profile   = ""                  #Change iam role here
  key_name               = "vti-academy-aws14" #Change key pairs here
}