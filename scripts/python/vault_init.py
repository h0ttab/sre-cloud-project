import requests
import argparse
import json

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('host', help='Target Vault host IP')
arg_parser.add_argument('port', help='Target Vault host API port')
args = arg_parser.parse_args()

VAULT_IP = args.host
VAULT_PORT = args.port
VAULT_INIT_FILE_PATH = './secrets/vault_init.json'
vault_init_url = f"http://{VAULT_IP}:{VAULT_PORT}/v1/sys/init"

is_vault_initialized = requests.get(vault_init_url).json()["initialized"]

if is_vault_initialized:
    print(f"HashiCorp Vault on host {VAULT_IP} has already been initialized")
    exit(1)
else:
    print(f"HashiCorp Vault is not initialized. Initializing now...\n")

vault_unseal_data = requests.post(vault_init_url, json={
    "secret_shares": 1,
    "secret_threshold": 1
}).json()

with open(VAULT_INIT_FILE_PATH, 'w') as file:
    if "errors" in vault_unseal_data:
        raise Exception(vault_unseal_data["errors"])
    
    file.write(json.dumps(vault_unseal_data))
    print(f"HashiCorp Vault on host {VAULT_IP} has been initialized. Bootstrap json has been saved to {VAULT_INIT_FILE_PATH}")