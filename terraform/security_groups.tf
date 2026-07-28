resource "yandex_vpc_security_group" "sg_app" {
  name        = "app-security-group"
  description = "App node security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  ingress {
    description    = "Allow SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  ingress {
    description    = "Allow HTTP:80"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  ingress {
    description    = "Allow HTTP:8080"
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  egress {
    description    = "Allow ALL"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_ci" {
  name        = "ci-security-group"
  description = "CI node security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  ingress {
    description    = "Allow Jenkins agents"
    protocol       = "TCP"
    port           = 50000
    v4_cidr_blocks = local.cloud_subnets
  }
}