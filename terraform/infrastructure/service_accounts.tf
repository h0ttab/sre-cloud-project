resource "yandex_iam_service_account" "registry_service_account" {
  folder_id   = var.folder_id
  name        = "container-registry-sa"
  description = "Container Registry service account"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_iam_service_account_key" "registry_sa_key" {
  service_account_id = yandex_iam_service_account.registry_service_account.id
  description        = "Container Registry service account access key"
}

resource "local_sensitive_file" "registry_sa_key_file" {
  filename = var.registry_sa_key
  content = jsonencode({
    id                 = yandex_iam_service_account_key.registry_sa_key.id
    service_account_id = yandex_iam_service_account_key.registry_sa_key.service_account_id
    created_at         = yandex_iam_service_account_key.registry_sa_key.created_at
    key_algorithm      = yandex_iam_service_account_key.registry_sa_key.key_algorithm
    public_key         = yandex_iam_service_account_key.registry_sa_key.public_key
    private_key        = yandex_iam_service_account_key.registry_sa_key.private_key
  })
}