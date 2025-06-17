# LS1028ARDB TSN Switch Setup Guide

This guide provides step-by-step instructions to set up the NXP LS1028A RDB board as a Time Sensitive Networking (TSN) switch or receiver. It also covers configuring a sender device such as a PC or any Ethernet enabled board with PTP support. The guide includes flashing the Linux image, installing necessary tools, configuring network interfaces, and integrating multiple TSN capable devices into a synchronized testbed.


---

## Prerequisites

### Hardware
- NXP LS1028A-RDB board (1x for switch, 1x for receiver), use LS1028A-RDB as receiver for preemption support.
- Sender e.g PC, BeagleBone Black (BBB) or LS1028A/LS1021A-TSN board (end nodes)
- Ethernet cables
- MicroSD card (>=8GB) for each board
- Serial-to-USB cable
- Linux host PC 

### Software
- Download and build the Yocto-based image for LS1028A: Follow the instructions here (https://www.nxp.com/docs/en/user-guide/RTEDGEYOCTOUG.pdf)
- `putty`,`minicom` or `screen` (for serial terminal)
- Optional: Wireshark, scapy (for traffic inspection)

---

## Sample Network Architecture

### Roles

| Device             | Role         | Purpose                                 |
|--------------------|--------------|-----------------------------------------|
| **LS1028A**        | TSN Switch   | Central PTP master, GCL scheduler       |
| **LS1028A**        | Receiver     | Collects traffic from end nodes         |
| **BBB / LS1021A**  | End Nodes    | Send traffic with PTP time sync         |
| **Linux PC**       | Host         | Optional Wireshark/logging node         |

### Topology Diagram

```plaintext
[NXP Board]      [BBB/PC]
swp0|             | eth0
    +-------------+
 swp1      |  swp2
     [LS1028A-RDB]
        (Switch)
          | swp1
     [LS1028A-RDB]
        (Receiver)


