resource "vault_auth_backend" "approle_backend" {
  type = "approle"
}

resource "vault_auth_backend" "userpass_backend" {
  type = "userpass"
}