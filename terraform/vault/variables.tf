variable "vault_server_ip" {
  type        = string
  description = "HasiCorp Vault server IP. Dynamically set by ./terraform/infrastructure/main.tf"
  sensitive   = true
}

variable "ssh_private_key_path" {
  type        = string
  description = "SSH private key filepath"
  default     = "../../secrets/ssh/cloud_ssh_key"
}