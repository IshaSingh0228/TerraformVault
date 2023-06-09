## Generating Dynamic Keys in AWS

##### Assuming that vault is up and running
##### I am using "aws" auth method. <br />

#### Create Vault Backend & IAM Role

1. Configure the credentials required to make AWS API calls and Configure the policies on the role. 
    Check file:  _iam_role -> resoure.tf_
2. Run ``` terraform init ``` -> ``` terraform plan ``` -> ``` terraform apply ```
3. You will observe two resources have been created , first is a secret engine for AWS and then a role for EC2 admin. Check the Vault UI.

#### Create an EC2 Instance with a short-lived credential

1. Check file: _EC2_instance -> resource.tf_
2. cd to the folder, Run ``` terraform init ``` -> ``` terraform plan ``` -> ``` terraform apply ```
3. Got to AWS Console -> Users, you can see a new user being created , this user will be deleted automatically by Vault provider once the lease expires after 300s as defined in the Vault backend
4. On EC2 console, you can see a new instance has been provisioned 



*docs to refer*: <br /> 
                - https://developer.hashicorp.com/vault <br />
                - https://developer.hashicorp.com/vault/api-docs/auth/aws?_ga=2.50646189.586193662.1678718510-466124567.1678718510#aws-auth-method-api <br />
                - https://registry.terraform.io/providers/hashicorp/vault/latest/docs <br />
 *YouTube videos*: <br /> 
                - https://www.youtube.com/watch?v=-EHmM5ocUsM&list=PLFkEchqXDZx7CuMTbxnlGVflB7UKwf_N3&index=4 <br />
                - https://www.youtube.com/watch?v=wfGzOduNoas&list=WL&index=3  <br />
*GitLab With Vault*: <br />
                - https://blog.revolve.team/2023/03/23/securing-your-terraform-deployment-on-aws-via-gitlab-ci-and-vault-part-2/
                - https://holdmybeersecurity.com/2021/03/04/gitlab-ci-cd-pipeline-with-vault-secrets/
