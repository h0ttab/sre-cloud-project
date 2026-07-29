resource "yandex_iam_service_account" "registry_service_account" {
  folder_id   = var.folder_id
  name        = "container-registry-sa"
  description = "Container Registry service account"
}

resource "yandex_container_registry_iam_binding" "registry_pusher" {
  registry_id = yandex_container_registry.container_registry.id
  role        = "container-registry.images.pusher"
  members = [
    "serviceAccount:${yandex_iam_service_account.registry_service_account.id}"
  ]
}

resource "yandex_container_registry_iam_binding" "registry_puller" {
  registry_id = yandex_container_registry.container_registry.id
  role        = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.registry_service_account.id}"
  ]
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