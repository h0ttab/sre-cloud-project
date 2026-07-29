import requests
import argparse
import json

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('host', help='Target Vault host IP')
arg_parser.add_argument('port', help='Target Vault host API port')
args = arg_parser.parse_args()

vault_ip = args.host
vault_port = args.port
vault_init_url = f"http://{vault_ip}:{vault_port}/v1/sys/init"
vault_init_filepath = './secrets/vault_init.json'

vault_initialized = requests.get(vault_init_url).json()["initialized"]

if vault_initialized:
    print(f"HashiCorp Vault on host {vault_ip} has already been initialized")
else:
    print(f"HashiCorp Vault is not initialized. Initializing now...")

vault_unseal_data = requests.post(vault_init_url, json={
    "secret_shares": 1,
    "secret_threshold": 1
}).json()

with open(vault_init_filepath, 'w') as file:
    if "errors" in vault_unseal_data:
        raise Exception(vault_unseal_data["errors"])
    file.write(json.dumps(vault_unseal_data))
    print(f"HashiCorp Vault on host {vault_ip} has been initialized. Bootstrap json has been saved to {vault_init_filepath}")