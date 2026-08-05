export VAULT_ADDR="http://$1:8200"
export VAULT_TOKEN=$(cat ./secrets/vault/vault_root_token)

vault auth enable -path=terraform-approle approle

vault policy write terraform-admin - <<EOF
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo", "patch", "subscribe", "recover"]
  subscribe_event_types = ["*"]
}
EOF

vault write auth/terraform-approle/role/terraform policies="terraform-admin"

cat > ./secrets/vault/approle/terraform_approle.json << EOF
{
    "role_id": "$(vault read -field=role_id auth/terraform-approle/role/terraform/role-id)",
    "secret_id": "$(vault write -f -field=secret_id auth/terraform-approle/role/terraform/secret-id)"
}
EOF

vault token revoke $VAULT_TOKEN
rm ./secrets/vault/vault_root_token