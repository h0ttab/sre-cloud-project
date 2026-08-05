variable "vault_server_ip" {
  type        = string
  description = "HasiCorp Vault server IP. Dynamically set by ./terraform/infrastructure/main.tf"
  sensitive   = true
}