resource "yandex_vpc_network" "vpc_net" {
  name      = "cloud_network"
  folder_id = var.folder_id

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_a" {
  folder_id      = var.folder_id
  v4_cidr_blocks = var.cidr_a
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = var.zone_a
  name           = "subnet_a"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_b" {
  folder_id      = var.folder_id
  v4_cidr_blocks = var.cidr_b
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = var.zone_b
  name           = "subnet_b"

  labels = {
    managed_by = "terraform"
  }
}