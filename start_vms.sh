#!/bin/bash
yc compute instance start "ci-server" &>/dev/null &
yc compute instance start "app-server" &>/dev/null &
wait
(
    cd ./terraform
    terraform apply --auto-approve &>/dev/null
)
echo "VMs has been started and Terraform state was successfully updated"