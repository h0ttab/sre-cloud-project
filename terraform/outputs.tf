output "app_node_public_ip" {
  description = "App node public IP"
  value       = yandex_compute_instance.app_node.network_interface.0.nat_ip_address
}