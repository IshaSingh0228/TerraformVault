#vault provider configuration
	provider "vault" {
		address = var.vault_addr
		token = var.vault_token
	}
