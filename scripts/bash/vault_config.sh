export VAULT_ADDR="http://$1:8200"
export VAULT_TOKEN=$(cat ./secrets/vault_root_token)
vault secrets enable --path=secret kv-v2
vault policy write jenkins ./vault/jenkins_policy.hcl

vault auth enable approle
vault write auth/approle/role/jenkins-role policies="jenkins"

vault read auth/approle/role/jenkins-role/role-id > ./secrets/jenkins_approle
vault write -f auth/approle/role/jenkins-role/secret-id >> ./secrets/jenkins_approle

vault kv put secret/jenkins/ycr container-registry-sa-key=@./secrets/container-registry-sa-key.json
vault kv put secret/jenkins/ssh app-node-ssh-key=@$(realpath ~/.ssh/yandex_cloud) app-node-ssh-username=ubuntu
vault kv put secret/jenkins/db username=$(openssl rand -hex 15) password=$(openssl rand -hex 15) passphrase=