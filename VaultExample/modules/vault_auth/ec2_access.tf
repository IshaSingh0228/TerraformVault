#Creates an AWS Secret Backend for Vault
#AWS secret backends can then issue AWS access keys and secret keys, once a role has been added to the backend
resource "vault_aws_secret_backend" "aws_ec2" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  path = "test"
  default_lease_ttl_seconds = "300"
  max_lease_ttl_seconds     = "600"
}

#Creates a role on an AWS Secret Backend for Vault.
#Roles are used to map credentials to the policies that generated them.
resource "vault_aws_secret_backend_role" "ec2-admin-role" {
  backend = vault_aws_secret_backend.aws_ec2.path
  name    = "ec2-admin-role"
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

#Reads AWS credentials from an AWS secret backend in Vault.
data "vault_aws_access_credentials" "creds" {
  backend = vault_aws_secret_backend.aws_ec2.path
  role    = "ec2-admin-role"
  region  = var.region
}