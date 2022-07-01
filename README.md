# ## This repository is to create vpc & ec2 from Terraform's module. Use this by default with IAM user of VTI
## Start to use terraform
## Prerequisites
- Terraform v1.2.2 or later [Link](https://www.terraform.io/downloads)
- AWSCLI ver2 [Link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- shell (sh), if you are using windows, you can use WSL [Link](https://docs.microsoft.com/en-us/windows/wsl/install)


## Problems
- IAM user is required to use MFA, mean that even we could get temporary accesskey and secretkey for getting a session, Terraform Provider AWS did not support this method [Link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)

- To handle this issue, we could have use AWS [credential_process](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#sourcing-credentials-from-external-processes)

Procedure:
   1. create temporary aws profile called `tf_temp`:
   ```
   aws configure set aws_access_key_id abc --profile tf_temp
   ```
   2. copy this file to /usr/loca/bin and make it can be execute:
   ```sh
   sudo cp ./mfa.sh /usr/local/bin/mfa.sh
   sudo chmod 755 /usr/local/bin/mfa.sh
   ```
   3. Create `tf` aws profile by this command:
   ```sh      
      echo """ 
[tf]
credential_process = sh -c 'mfa.sh 2> "'$(tty)'"'
      """ >> ~/.aws/credentials
   ```   
   The profile looks like:
   ```sh
[tf_temp]
aws_access_key_id = redacted
aws_secret_access_key = redacted
aws_session_token = redacted
[tf]
credential_process = sh -c 'mfa.sh 2> $(tty)'
   ```
## Usage
~~#Please makes changes in ./main.tf if you want to apply this to another account~~

~~1. Install AWS CLI, configure aws access keys : https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html~~
~~2. Install Terraform : https://learn.hashicorp.com/tutorials/terraform/install-cli~~
~~3. Download the files, Use terminals or powershell,... and cd to ../aws14-terraform~~
- Deploy
```sh
cd aws14-terraform
terraform fmt
terraform plan
terraform apply
```
- Destroy
```sh
terraform destroy
```
~~4. - Initilize modules : terraform init~~
~~   - Review code       : terraform plan ~~
~~   - Launch            : terraform apply -auto-approve ~~
~~   - Destroy           : terraform destroy -auto-approve~~

5. Folder structure :
  - aws14-terraform
     - main.tf
     - module
        - Ec2
           - main.tf
           - varriables.tf
           - outputs.tf
        - Networking
           - main.tf
           - varriables.tf
           - outputs.tf
