resource "vault_policy" "admin_policy" {
  name   = "admin"
  policy = <<-EOT
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo", "patch", "subscribe", "recover"]
  subscribe_event_types = ["*"]
}
EOT
}

resource "vault_policy" "jenkins_policy" {
  name   = "jenkins"
  policy = <<-EOT
path "secret/data/jenkins/*" {
    capabilities = ["read"]
}
EOT
}