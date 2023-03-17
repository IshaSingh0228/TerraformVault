We must be familiar with IaC tool To provision and configure infrastructure, we use configuration files in Terraform.
Whenever we create resources such as EC2 instances, S3 buckets, or databases, it is necessary to configure the AWS_ACCESS_KEY, AWS_SECRET_KEY, and region so 
that Terraform can use these credentials to set up the provider that we specify.

Although *aws configure* or a text file can be used to pass credentials, it is strongly discouraged from a security perspective. These long-lived static credentials 
can cause significant damage if they are leaked. Therefore, a better solution is needed that can generate short-lived credentials dynamically,which can expire and enhance security.

**Hashicorp Vault** is a widely used cloud-agnostic system for managing secrets. It provides identity-based encryption and secrets management capabilities. 
In other words, Vault ensures that clients (such as users, machines, or applications)are authorized and validated before granting them access to sensitive data or secrets stored within the system.
Common Secrets that can be stores are username and password, certificates, SSH keys, API keys and others.

Use Cases
----------------
1. Static and Dynamic Secrets
2. Data Encryption
3. Identity based Access
4. Key Management

Ways to Use Vault
------------------
1.CLI (API) https://developer.hashicorp.com/vault/api-docs <br />
2.UI <br />
3.Hashicorp Cloud Platform <br />

## Install Vault: 

  - Vault can be installed either on a local development or on virtual machine <br />
  - Link to install : https://developer.hashicorp.com/vault/docs/install <br /> 
	- Check installation : ``` vault -v ```
	- After installing Vault, the server can be started in two modes: **Dev Mode** and **Server Mode**  <br /> 
	
	
DEV Mode
---------
- To Start vault in dev mode run: ``` vault server -dev ```
- Explore cmds option available: ``` vault server -dev --help ```
- You should see the following logs onto your console
```
$ vault server -dev
==> Vault server configuration:
             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.19.4
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: false, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.12.3, built 2023-02-02T09:07:27Z
             Version Sha: 209b3dd99fe8ca320340d08c70cff5f620261f9b
==> Vault server started! Log data will stream in below:
...
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.
You may need to set the following environment variables:
PowerShell:
    $env:VAULT_ADDR="http://127.0.0.1:8200"
cmd.exe:
    set VAULT_ADDR=http://127.0.0.1:8200
The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: H4gmRGw9/aAamdeDOk62DBQfLVXOj9WOKHpEcSFpu6Y=
Root Token: hvs.zaNtoxvmVoZJiwaABTno6Vam

```
- To connect to your Vault server, make sure to set the environment variable *VAULT_ADDR* with the server's address as specified in the logs. Copy the *root token*,
  which serves as an authentication token for accessing Vault. Keep this token secure. By default, Vault uses port 8200 for communication.
- Run Cmd: ``` vault status ``` , you will see an initialized and unsealed server up and running
```
$ vault status    
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.12.3
Build Date      2023-02-02T09:07:27Z
Storage Type    inmem
Cluster Name    vault-cluster-fd152780
Cluster ID      6719b05d-0e5c-c942-15b2-58dd0e22d1b7
HA Enabled      false
```
- Connect to the server with the root token key received on "http://127.0.0.1:8200"

#### Properties:

1. *Initialized and unsealed* - The server will be automatically initialized and unsealed. 
You don't need to use "vault operator unseal".
2. *In-memory storage* - All data is stored (encrypted) in-memory. Therefor, not recommended for production use.
3. *Bound to local address without TLS* - The server is listening on 127.0.0.1:8200 (the default server address) without TLS.
4. *Automatically Authenticated* - The server stores your root access token so vault CLI access is ready to go. 
		If you are accessing Vault via the API, you'll need to authenticate using the token printed out.
5. *Single unseal key* - The server is initialized with a single unseal key. The Vault is already unsealed.
6. *Key Value store mounted* - A v2 KV secret engine is mounted at "secret/".

Server Mode
-----------
- To start the server in Server mode, run command: ``` vault server -config=<path_to_file> ``` <br />
  This mode is recommended for a non-development environment, stage or production environemnt. It requires a configuration file, which can be either HCL or JSON format. 
  Example of how the configuration file can be structured
```
ui=true
storage "file" {
  path = "C:/Users/Documents/My_Projects/TerraformVault/data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}
```

- Set the *VAULT_ADDR* environment variable: ``` export VAULT_ADDR=http://127.0.0.1:8200 ```
- Check the status of your Vault server, run the command: ``` vault status ``` , you should see that the server is uninitialized and sealed. 
  This is in contrast to Dev mode, where the server is initialized and unsealed by default.
```
$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.13.0
Build Date         2023-03-01T14:58:13Z
Storage Type       file
HA Enabled         false
```
 - To initialize the vault, run: ``` vault operator init -key-shares=5 -key-threshold=3 ```
   Here, I am initializing it with *5 unseal keys* and atleast *2 keys* to unseal the vault
   At the time of initialization, we will get two information
    - Root Token 
    - Unseal keys 
 - Once initialization is completed, you will receive 5 keys and a Root Token. Make sure to copy them and keep it secure.
 - Run ``` vault status ``` again, and you will see * Initialization status* set to true, and total key shares and threadhold keys values are set.

```
$ vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.13.0
Build Date         2023-03-01T14:58:13Z
Storage Type       file
HA Enabled         false
```
 - The vault is still sealed, to UnSeal the vault run: ``` vault operator unseal ```
   Give the unseal keys, you will see the *Unseal Progress* line been updated. 
   Run the unseal command again, providing different keys from the shared keys until the threshold is reached. Vault is now unsealed and ready.
   
```
$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.13.0
Build Date      2023-03-01T14:58:13Z
Storage Type    file
Cluster Name    vault-cluster-8f41c9d4
Cluster ID      58832970-67d0-ef36-fe72-7ebb1b0fe0e8
HA Enabled      false
```
- Connect to the server with the root token key received on "http://127.0.0.1:8200"

DONE!!!!
