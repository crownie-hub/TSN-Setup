import sys
from scapy.all import Ether, IP, ICMP, Dot1Q, Raw, sendp

def create_tsn_packet(dst_mac, dst_ip, vlan_id, priority_pcp, packet_size, content_label):
    """
    Create a TSN Ethernet frame with VLAN tag, priority, and content.
    """
    header_size = 0  # Adjust if needed
    payload_size = packet_size - header_size
    payload = (content_label * ((payload_size // len(content_label)) + 1))[:payload_size]
    packet = Ether(dst=dst_mac) / Dot1Q(vlan=vlan_id, prio=priority_pcp) / IP(dst=dst_ip) / ICMP() / Raw(load=payload.encode())
    return packet

def send_tsn_traffic(priority, content_label, count=1000, inter=0.0005, iface="eth0"):
    """
    Send TSN traffic with specified priority and custom content.
    """
    dst_mac = "16:4e:da:13:03:fd"
    dst_ip = "192.168.5.5"
    vlan_id = 100
    packet_size = 1448

    packet = create_tsn_packet(dst_mac, dst_ip, vlan_id, priority, packet_size, content_label)
    print(f"Sending {count} frames with PCP {priority} ({content_label}) on {iface}")
    sendp(packet, iface=iface, count=count, inter=inter, verbose=True)

if __name__ == "__main__":
    usage = "Usage: sudo python3 send_tsn_frames.py <priority: 0-7>\n" \
            "Example: sudo python3 send_tsn_frames.py 6"
    
    if len(sys.argv) != 2:
        print(usage)
        sys.exit(1)

    try:
        prio = int(sys.argv[1])
        if prio not in range(8):
            raise ValueError

        # Define label by priority
        content_map = {
            7: "HIGH_PRIORITY_DATA",
            6: "MID_PRIORITY_FLOW",
            2: "LOW_PRIORITY_TRAFFIC"
        }
        content_label = content_map.get(prio, f"PCP_{prio}_TRAFFIC")

        send_tsn_traffic(priority=prio, content_label=content_label)

    except ValueError:
        print("Priority must be an integer between 0 and 7.\n" + usage)
        sys.exit(1)
