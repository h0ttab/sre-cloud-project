resource "vault_userpass_auth_backend_user" "admin_userpass" {
  mount                    = vault_auth_backend.userpass_backend.path
  username                 = local.admin_credentials.username
  password_hash_wo         = local.admin_credentials.password_hash
  password_hash_wo_version = 1
  token_policies           = [vault_policy.admin_policy.name]
}

locals {
  content           = file("${path.module}/../../secrets/vault/vault_admin_credentials.json")
  admin_credentials = jsondecode(local.content)
}

resource "vault_approle_auth_backend_role" "jenkins_approle" {
  backend        = vault_auth_backend.approle_backend.path
  role_name      = "jenkins"
  token_policies = [vault_policy.jenkins_policy.name]
}

resource "vault_approle_auth_backend_role_secret_id" "jenkins_approle_secret_id" {
  backend   = vault_auth_backend.approle_backend.path
  role_name = vault_approle_auth_backend_role.jenkins_approle.role_name
}

data "vault_approle_auth_backend_role_id" "jenkins_approle" {
  backend   = vault_auth_backend.approle_backend.path
  role_name = vault_approle_auth_backend_role.jenkins_approle.role_name
}

resource "local_sensitive_file" "jenkins_approle_credentials" {
  filename = "${path.module}/../../secrets/vault/approle/jenkins_approle.json"
  content = jsonencode({
    "role_id"   = data.vault_approle_auth_backend_role_id.jenkins_approle.role_id,
    "secret_id" = vault_approle_auth_backend_role_secret_id.jenkins_approle_secret_id.secret_id
  })
}