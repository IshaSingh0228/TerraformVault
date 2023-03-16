output "backend" {
  value = vault_aws_secret_backend.aws_ec2.path
}

output "role" {
  value = vault_aws_secret_backend_role.ec2-admin-role.name
}

output "access_key" {
    value=data.vault_aws_access_credentials.creds.access_key
    sensitive = true
}

output "secret_key" {
    value=data.vault_aws_access_credentials.creds.secret_key
    sensitive = true
}