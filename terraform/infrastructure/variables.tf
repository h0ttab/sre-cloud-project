variable "terraform_sa_key" {
  type        = string
  description = "Terraform service account JSON-key filepath"
  default     = "../../secrets/cloud/terraform-sa-key.json"
}

variable "registry_sa_key" {
  type        = string
  description = "Container Registry service account JSON-key filepath"
  default     = "../../secrets/cloud/container-registry-sa-key.json"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH-key filepath"
  default     = "../../secrets/ssh/cloud_ssh_key.pub"
}

variable "ssh_private_key" {
  type        = string
  description = "Private SSH-key filepath for Ansible inventory.ini auto-generation"
  default     = "../secrets/ssh/cloud_ssh_key"
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  sensitive   = true
}

variable "ubuntu_family" {
  type        = string
  description = "Ubuntu 24.04 Image family name"
  default     = "ubuntu-24-04-lts"
}

variable "zone_a" {
  type        = string
  description = "YandexCloud availability zone RU-A"
  default     = "ru-central1-a"
}

variable "zone_b" {
  type        = string
  description = "YandexCloud availability zone RU-B"
  default     = "ru-central1-b"
}

variable "cidr_a" {
  type        = list(string)
  description = "CIDR block for subnet A"
  default     = ["10.10.1.0/24"]
}

variable "cidr_b" {
  type        = list(string)
  description = "CIDR block for subnet B"
  default     = ["10.10.2.0/24"]
}