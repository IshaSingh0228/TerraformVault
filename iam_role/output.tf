output "backend" {
  value =  vault_aws_secret_backend.aws_ec2.path
}

output "role" {
  value = vault_aws_secret_backend_role.vault-ec2-admin.name
}