#!/bin/bash
#st of switch ports
PORTS=("swp0" "swp1" "swp2" "swp3")
PTP_IPS=("224.0.1.129" "224.0.0.107")
PTP_ETH_TYPE="0x88f7"

# Setup traffic control (tc) filters per port
setup_tc_filters() {
    local dev="$1"
    echo "Configuring tc filters for $dev..."

    tc qdisc add dev "$dev" clsact 2>/dev/null

    # Setup chain jumps
    for chain in 0 10000 11000 12000 20000 21000; do
        next_chain=$((chain + 10000))
        tc filter add dev "$dev" ingress chain "$chain" pref 49152 flower skip_sw \
            action goto chain "$next_chain" 2>/dev/null
    done

    # Add PTP ethertype trap
    tc filter add dev "$dev" ingress chain 20000 protocol $PTP_ETH_TYPE flower skip_sw \
        action trap action goto chain 21000 2>/dev/null

    # Add IP multicast address traps
    for ip in "${PTP_IPS[@]}"; do
        tc filter add dev "$dev" ingress chain 20000 protocol ip flower skip_sw \
            dst_ip "$ip" action trap action goto chain 21000 2>/dev/null
    done
}

# Setup devlink buffer thresholds
setup_devlink() {
    local ingressport=0
    local egressport=1
    echo "Configuring devlink buffer thresholds..."

    for tc in {0..7}; do
        devlink sb tc bind set pci/0000:00:00.5/$ingressport sb 0 tc "$tc" type ingress pool 0 th 3000
        devlink sb tc bind set pci/0000:00:00.5/$ingressport sb 1 tc "$tc" type ingress pool 0 th 10
        devlink sb tc bind set pci/0000:00:00.5/$egressport sb 0 tc "$tc" type egress pool 1 th 3000
        devlink sb tc bind set pci/0000:00:00.5/$egressport sb 1 tc "$tc" type egress pool 1 th 10
    done
}

# Setup ebtables to trap (not bridge) PTP
setup_ebtables() {
    echo "Setting ebtables rules..."

    ebtables -t broute -A BROUTING -p 0x88F7 -j DROP
    ebtables -t broute -A BROUTING -p 0x0800 --ip-proto udp --ip-dport 320 -j DROP
    ebtables -t broute -A BROUTING -p 0x0800 --ip-proto udp --ip-dport 319 -j DROP
}

# Main execution
for port in "${PORTS[@]}"; do
    setup_tc_filters "$port"
done

setup_ebtables
setup_devlink

echo " PTP trap setup complete."
