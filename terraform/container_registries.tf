resource "yandex_container_registry" "container_registry" {
  folder_id = var.folder_id
  name      = "container-registry"

  labels = {
    managed_by = "terraform"
  }
}

output "container_registry_id" {
  value = "Yandex Container Registry ID: ${yandex_container_registry.container_registry.id}"
}