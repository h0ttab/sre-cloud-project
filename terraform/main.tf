resource "yandex_vpc_network" "vpc_net" {
  name = "cloud_network"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_a" {
  v4_cidr_blocks = ["10.10.1.0/24"]
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = "ru-central1-a"
  name           = "subnet_a"

  labels = {
    managed_by = "terraform"
  }
}

resource "yandex_vpc_subnet" "subnet_b" {
  v4_cidr_blocks = ["10.10.2.0/24"]
  network_id     = yandex_vpc_network.vpc_net.id
  zone           = "ru-central1-b"
  name           = "subnet_b"

  labels = {
    managed_by = "terraform"
  }
}