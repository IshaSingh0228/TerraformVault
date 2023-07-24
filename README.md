## Generating Dynamic Keys in AWS

##### Assuming that vault is up and running

### METHOD 1: Creating AWS Secret Engine using Vault CLI

1. Enable the AWS secrets engine with the following command:
```
   $vault secrets enable -path=aws aws
```
Output: Success! Enabled the aws secrets engine at: aws/

2. Create a USER with the correct permissions specific for Vault in AWS and configure like below:
  ```
    $vault write aws/config/root access_key=<access-key> secret_key=<secret-key> region=<region>
```
OUTPUT: Success! Data written to: aws/config/root

3. Create a role policy(my-role), which will be used to generate user credentials against this role or specify policy ARNs 
```
$vault write aws/roles/my-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
```
OUTPUT: Success! Data written to: aws/roles/my-role

4. Vault will create an IAM user and attach the policy (my-role) to the user. Vault then creates and returns an access key and secret key for the user.
```
   $vault read aws/creds/my-role
   Key                Value
   ---                -----
   lease_id           aws/creds/my-role/GtFr97NplvTPB45jqAxZNPk2
   lease_duration     768h
   lease_renewable    true
   access_key         A********I7
   secret_key         5*********iC
   security_token     <nil>
```
This access-key and secret-key then can be used in terraform to create EC2 in aws

5. In the AWS Console these users will show up with the user name of ```vault-token-$role-$timestamp``` i.e vault-root-my-role-1690204287-5354, which will have the attached policy my-role to access ec2 instance in AWS.

    
### METHOD 2: Create Vault Backend & IAM Role using TERRAFORM

1. Configure the credentials required to make AWS API calls and Configure the policies on the role. 
    Check file:  _iam_role -> resoure.tf_
2. Run ``` terraform init ``` -> ``` terraform plan ``` -> ``` terraform apply ```
3. You will observe two resources have been created , first is a secret engine for AWS and then a role for EC2 admin.
4. Confirm the same by login to Vault UI.

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
