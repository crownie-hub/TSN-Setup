This guide provides the step-by-step configuration of the network interfaces, VLANs, and IP addresses for the TSN switch (LS1028A-RDB) enetc ports and other nodes in the setup.


## On the sender node

### Configure port with static IPs

```bash
sudo ip link set eth0 up

sudo ip addr add 192.168.2.1/24 dev eth2
```
You can follow the same for other sender nodes using their interfaces. Make sure they are on the same subnet.


### Configure VLAN ID at the sender node, this willconfigure the ingress port queue to map priority to frames.
```bash
ip link add link eth0 name eth0.100 type vlan id 100 ingress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7 egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
```

---

## On TSN Switch Bash Script Setup (LS1028A-RDB)

To configure the LS1028A as a TSN switch with VLAN filtering and a bridge across switch ports, create and run the following script.

### Create the Script

Create a file named `switch-setup.sh` and paste the following content:

```bash
#!/bin/bash

# Bring up interfaces
ip link set eno2 up
ip link set swp0 up
ip link set swp1 up
ip link set swp2 up
ip link set swp3 up

# Create bridge with VLAN filtering enabled
ip link add name br0 type bridge vlan_filtering 1

# Add switch ports to bridge
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
    bridge vlan add dev $port vid 1 pvid untagged
    bridge vlan add dev $port vid 100
done


```

###  Make the Script Executable and run

```bash
chmod +x tsn-switch-setup.sh
sudo ./tsn-switch-setup.sh
```

This sets up your TSN switch bridge `br0` with ports `swp0–swp3` assuming all ports are active, all part of VLAN 100, and ensures all necessary interfaces are up. 

### Confirm the bridge VLAN config, run:

```bash
bridge vlan show
```
## Output
port              vlan-id
swp0              1 PVID Egress Untagged
                  100
swp1              1 PVID Egress Untagged
                  100
swp2              1 PVID Egress Untagged
                  100
swp3              1 PVID Egress Untagged
                  100
br0               1 PVID Egress Untagged


---

## On the receiver board (e.g LS1028a)

```bash
sudo ip link set swp1 up

sudo ip addr add 192.168.2.5/24 dev swp1
```

 Do a ping test from the sender to receiver or vice versa to confirm they can all communicate. This switch is acting as a bridge, you do not need to set an ip address for the bridge for the setup to work.





