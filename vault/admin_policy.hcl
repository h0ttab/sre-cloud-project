path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo", "patch", "subscribe", "recover"]
  subscribe_event_types = ["*"]
}