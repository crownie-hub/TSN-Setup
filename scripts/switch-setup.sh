#!/bin/bash

# Bring up interfaces
ip link set eno2 up
ip link set swp0 up
ip link set swp1 up
ip link set swp2 up
ip link set swp3 up

# Create bridge with VLAN filtering enabled
ip link add name br0 type bridge vlan_filtering 1

ip link set dev swp0 master br0
ip link set dev swp1 master br0
ip link set dev swp2 master br0
ip link set dev swp3 master br0

# Bring up bridge interface
ip link set dev br0 up

# Assign VLAN ID 100 to all switch ports
bridge vlan add dev swp0 vid 100
bridge vlan add dev swp1 vid 100
bridge vlan add dev swp2 vid 100
bridge vlan add dev swp3 vid 100

# Show VLAN configuration
bridge vlan show

# Add VLAN 1 (default PVID) and VLAN 100 to each port
for port in swp0 swp1 swp2 swp3; do
    bridge vlan add dev $port vid 100
done

