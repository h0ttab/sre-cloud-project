#!/bin/bash
set -e
yc compute instance start "ci-server" 2>/dev/null &
yc compute instance start "app-server" 2>/dev/null &
wait
(
    cd ./terraform
    terraform apply --auto-approve 2>/dev/null
)
echo "VMs has been started and Terraform state was successfully updated"