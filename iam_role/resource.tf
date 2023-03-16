#vault provider configuration
provider "vault" {
	address = var.vault_addr
	token = var.vault_token
}

#Configuring creds for API call to AWS
#Creates an AWS Secret Backend for Vault
resource "vault_aws_secret_backend" "aws_ec2" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "us-east-1"
  path = "dynamic_trial"

  default_lease_ttl_seconds = "300"
  max_lease_ttl_seconds     = "600"
}

#Configuring the policies on the role
#Creates a role on an AWS Secret Backend for Vault.
#Roles are used to map credentials to the policies that generated them.
resource "vault_aws_secret_backend_role" "vault-ec2-admin" {
  backend = vault_aws_secret_backend.aws_ec2.path
  name    = "vault-ec2-admin"
  credential_type = "iam_user"
  policy_document =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}