terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.10.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
  }
  required_version = ">= 1.15.8"
}

provider "vault" {
  address = "http://${var.vault_server_ip}:8200"
  auth_login {
    path = "/auth/terraform-approle/login"

    parameters = {
      role_id   = local.terraform_approle.role_id
      secret_id = local.terraform_approle.secret_id
    }
  }
}

locals {
  terraform_approle = jsondecode(file("${path.module}/../../secrets/vault/approle/terraform_approle.json"))
}