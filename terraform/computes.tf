resource "yandex_compute_instance" "app_node" {
  name        = "app_server"
  folder_id   = var.folder_id
  zone        = var.zone_a
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    security_group_ids = [yandex_vpc_security_group.sg_app.id]
    nat                = true
  }

  scheduling_policy {
    preemptible = true # https://yandex.cloud/ru/docs/compute/concepts/preemptible-vm
  }

  # YandexCloud required ssh-key to be passed in the format "{username}:{key_itself}"
  metadata = {
    ssh-keys = "ubuntu:${file(pathexpand(var.ssh_public_key))}" # "ubuntu" - username, ${} - formatted string
  }

  labels = {
    managed_by = "terraform"
  }
}