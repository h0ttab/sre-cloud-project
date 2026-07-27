#!/bin/bash
yc compute instance stop "ci-server" &>/dev/null &
yc compute instance stop "app-server" &>/dev/null &
wait
echo "VMs has been stopped"