provider "vault" {
	address = var.vault_addr
	token = var.vault_token
}

#The module sends out a request to Terraform to provide 'vault_aws_access_credentials' for the role that 
#we created earlier.
#Reads AWS credentials from an AWS secret backend in Vault.
data "vault_aws_access_credentials" "creds" {
  backend = "dynamic_trial"
  role    = "vault-ec2-admin"
  region  = var.region
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region	 = var.region
}

#Creates EC2 instance of aws with the temporaray creds
resource "aws_instance" "ec2-vault-instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  tags = {
    Name = "ec2-vault-instance"
  }
}