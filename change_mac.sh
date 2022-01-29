#!/bin/bash

sudo ip link set dev enp3s0 down
sleep 3s
sudo ip link set dev enp3s0 address 99:99:99:99:99:98
sleep 1s
sudo ip link set dev enp3s0 up

ifconfig
read -rsp $'Done...\n'
