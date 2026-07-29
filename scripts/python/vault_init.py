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
VAULT_API_URL = f"http://{VAULT_IP}:{VAULT_PORT}/v1"

def get_initialization_status():
    response = requests.get(f"{VAULT_API_URL}/sys/init")
    initialization_flag = response.json()["initialized"]
    if initialization_flag is None:
        raise Exception(f"Vault initialization status is unknown. Response: \n{response.json()}")
    else:
        return initialization_flag

def get_unseal_keys(is_initialized:bool):
    if is_initialized:
        with open(VAULT_INIT_FILE_PATH, 'r') as file:
            return json.loads(file.read())
    
    payload = {
        "secret_shares": 1,
        "secret_threshold": 1
    }

    response = requests.post(f"{VAULT_API_URL}/sys/init", json.dumps(payload))
    return response.json()

def save_unseal_keys(keys_json):
    with open(VAULT_INIT_FILE_PATH, 'w') as file:
        if "errors" in keys_json:
            raise Exception(keys_json["errors"])
        
        file.write(json.dumps(keys_json))
        print(f"HashiCorp Vault on host {VAULT_IP} has been initialized. Bootstrap json has been saved to {VAULT_INIT_FILE_PATH}")

def get_seal_status():
    response = requests.get(f"{VAULT_API_URL}/sys/seal-status")
    data = response.json()
    if data["sealed"] is None:
        raise Exception(f"Vault seal status is unknown. Response: \n{data}")
    else:
        return data["sealed"]

def unseal_vault(key):
    payload = {"key": key}
    
    response = requests.post(f"{VAULT_API_URL}/sys/init", json.dumps(payload))
    data = response.json()

    if data["sealed"] is None or data["sealed"] is False:
        raise Exception(f"Failed to unseal vault. Response: \n{data}")
    else:
        print("Vault has been successfuly unsealed")


if __name__ == "__main__":

    if get_initialization_status() is True:
        print(f"HashiCorp Vault on host {VAULT_IP} has already been initialized. Trying to unseal...")    
    else:
        print(f"HashiCorp Vault is not initialized. Initializing now...\n")
        unseal_keys_json = get_unseal_keys(is_initialized=False)
        save_unseal_keys(unseal_keys_json)
        print(f"Vault initialized!")

    if get_seal_status() is True:
        print("Fetching unseal keys...")
        keys = get_unseal_keys(is_initialized=True)
        print("Keys fetched! Unsealing Vault...")
        for key in keys:
            unseal_vault(key)
        print(f"All keys used. Vault seal status is: {get_seal_status()}")
    else:
        print("Vault is already unsealed. Exiting...")
        exit(1)