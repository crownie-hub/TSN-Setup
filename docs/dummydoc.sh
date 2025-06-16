es */
ip addr add 192.168.1.1/24 dev eth2
ip addr add 192.168.2.1/24 dev eth3
ip addr add 192.168.3.1/24 dev eth4
/* swp3 is only available when using ENETC port as DSA CPU port */
ip addr add 192.168.4.1/24 dev eth5
/* master interface to be brought up first – up by default */
ip link set eth1 up
/* bring up the switch slave interfaces */ 
ip link set eth2 up
 ip link set eth3 up 
 ip link set eth4 up
/* swp3 is only available when using ENETC port as DSA CPU port */
ip link set eth5 up

sudo ip route add default via 192.168.0.30 dev eno0


tc qdisc replace dev swp1 root taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues
1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 001000000 sched-entry S 0x10 500000
sched-entry S 0x05 500000 flags 0x2

ptp4l -i swp0 -i swp1 -i swp2 -i swp3 -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log 2>&1 &
sudo phc2sys -s eth0 -O 0 -S 0.00002 -m > phc2sys.log 2>&1 &
hwstamp_ctl -i eth1 -r 1
ethtool --set-frame-preemption eth1 preemptible-queues-mask 0x04 min-frag-
size 60


sudo phc2sys -s eth0 -O 0 -S 0.00002 -m > /var/log/phc2sys.log 2>&1 &    tc qdisc add dev eth0 clsact

sudo phc2sys -s swp1 -O 0 -S 0.00002 -m > /var/log/phc2sys.log 2>&1 &

 ptp4l -i swp0 -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log
 
 export PATH=/usr/local/zeek/bin:$PATH
 b:~# ethtool --show-frame-preemption swp1
 
isochron send --interface eth0 --dmac 16:4e:da:13:03:fd --priority 2 --vid 100 \
--base-time 0 --cycle-time 45000 --shift-time 40000 --advance-time 90000 \
--num-frames 10000 --frame-size 1472 --client 192.168.5.5 --quiet
sed -i '/^UDP_MAX=.*/a VLAN_ID=100\nVLAN_P=2'
ptp4l -i swp0 -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log 2>&1 &