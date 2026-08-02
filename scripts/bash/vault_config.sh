export VAULT_ADDR="http://$1:8200"
export VAULT_TOKEN=$(cat ./secrets/vault_root_token)
vault secrets enable --path=secret kv-v2
vault kv put secret/jenkins/ycr key.json=@./secrets/container-registry-sa-key.json
vault policy write jenkins ./vault/jenkins_policy.hcl
vault auth enable approle
vault write auth/approle/role/jenkins-role policies="jenkins"
vault read auth/approle/role/jenkins-role/role-id > ./secrets/jenkins_approle
vault write -f auth/approle/role/jenkins-role/secret-id >> ./secrets/jenkins_approle