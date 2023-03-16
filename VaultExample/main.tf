module "vault_out"{
    source="C:/Users/m1062222/OneDrive - Granicus/Documents/My_Projects/TerraformVault/VaultExample/vault_auth"
}

module "provider_cred"{
    source="C:/Users/m1062222/OneDrive - Granicus/Documents/My_Projects/TerraformVault/VaultExample/modules/providers"
    access_key=module.vault_out.access_key
    secret_key=module.vault_out.secret_key

}

module "my_ec2"{
    source="C:/Users/m1062222/OneDrive - Granicus/Documents/My_Projects/TerraformVault/VaultExample/modules/ec2"
    ami="ami-005f9685cb30f234b"
    instance_type="t2.micro"
}