import sys
sys.path.append('/home/debian/.local/lib/python3.9/site-packages')
from scapy.all import Ether, IP, ICMP, Dot1Q, Raw, sendp


dst_mac = "16:4e:da:13:03:fd"
dst_ip = "192.168.5.5"
priority_pcp = 2
packet_size = 1448
header_size = 0

payload_size = packet_size - header_size

packet = Ether(dst=dst_mac) / Dot1Q(vlan=100, prio=priority_pcp) / IP(dst=dst_ip) / ICMP() / Raw(load=b'\x00' * payload_size)
sendp(packet, iface="eth0", loop=1, inter=0.0005, verbose=True)
#sendpfast([packet]*1000, iface="eth0", loop=1)
