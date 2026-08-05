resource "vault_kv_secret_v2" "ycr_secret" {
  name  = "jenkins/ycr"
  mount = vault_mount.kvv2.path
  data_json_wo = jsonencode({
    container-registry-sa-key = file("${path.module}/../../secrets/cloud/container-registry-sa-key.json")
  })
  data_json_wo_version = 1
}

resource "vault_kv_secret_v2" "ssh_secret" {
  name  = "jenkins/ssh"
  mount = vault_mount.kvv2.path
  data_json_wo = jsonencode({
    app-node-ssh-key      = file(pathexpand("./secrets/ssh/cloud_ssh_key"))
    app-node-ssh-username = "ubuntu"
  })
  data_json_wo_version = 1
}

resource "vault_kv_secret_v2" "db_secret" {
  name  = "jenkins/db"
  mount = vault_mount.kvv2.path
  data_json_wo = jsonencode({
    username = random_string.db_username.result
    password = random_password.db_password.result
  })
  data_json_wo_version = 1
}

resource "random_string" "db_username" {
  length  = 16
  special = false
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "_-!"
}