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