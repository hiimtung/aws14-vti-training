# aws14-vti-training
#Start to use terraform
This repository is to create vpc & ec2 from Terraform's module. Use this by default with IAM user of VTI
Please makes changes in ./main.tf if you want to apply this to another account
1. Install AWS CLI, configure aws access keys : https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
2. Install Terraform : https://learn.hashicorp.com/tutorials/terraform/install-cli
3. Download the files, Use terminals or powershell,... and cd to ../aws14-terraform
4. - Initilize modules : terraform init
   - Review code       : terraform plan 
   - Launch            : terraform apply -auto-approve 
   - Destroy           : terraform destroy -auto-approve 
