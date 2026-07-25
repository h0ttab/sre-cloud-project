resource "yandex_vpc_network" "vpc_net" {
  name = "cloud_network"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_a" {
  v4_cidr_blocks = var.cidr_a
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = var.zone_a
  name           = "subnet_a"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_b" {
  v4_cidr_blocks = var.cidr_b
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = var.zone_b
  name           = "subnet_b"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_compute_instance" "app_node" {
  name        = "app_server"
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
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
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

data "yandex_compute_image" "ubuntu_image" {
  family = var.ubuntu_family
}