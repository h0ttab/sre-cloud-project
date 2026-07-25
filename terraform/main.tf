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

resource "yandex_vpc_security_group" "sg_app" {
  name        = "app-security-group"
  description = "App node security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  ingress {
    description    = "Allow SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTP:80"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTP:8080"
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow ALL"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "ubuntu_image" {
  family = var.ubuntu_family
}