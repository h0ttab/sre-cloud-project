terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.6.0"
    }
  }
  required_version = ">= 1.15.8"
}

provider "yandex" {
  service_account_key_file = pathexpand(var.terraform_sa_key)
  zone                     = var.zone_a
}