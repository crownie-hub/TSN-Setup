This guide shows how to set up PTP (IEEE 1588) on each device in a TSN testbed — including the Grandmaster TSN switch, sender, and receiver. It uses `linuxptp` tools: `ptp4l`, and `phc2sys`

---

## Common Requirements

* Boards:
  LS1028A-RDB (used as Grandmaster, switch, or receiver)
  BeagleBone Black, LS1021A, or other TSN-capable boards (slaves)

* Software:
  Linux with `linuxptp` installed (`ptp4l`, `phc2sys`)

* Network:
  Devices must be connected via Ethernet
  UDP ports 319 and 320 must be open

---

## Shared PTP Configuration File (`ptp4l.conf`)

Example config in `/etc/linuxptp/ptp4l.conf` on BBB, for NXP boards, it is in `/etc/ptp4l.cfg/default.cfg` or place it in the working directory where you run `ptp4l`.

```
[global]
[global]
#
# Default Data Set
#
twoStepFlag             1
slaveOnly               0
socket_priority         0
priority1               128
priority2               128
domainNumber            0
#utc_offset             37
clockClass              248
clockAccuracy           0xFE
offsetScaledLogVariance 0xFFFF
free_running            0
freq_est_interval       1
dscp_event              0
dscp_general            0
dataset_comparison      ieee1588
G.8275.defaultDS.localPriority  128
maxStepsRemoved         255
#
...
```

---
For the slaves and grandmaster, change `transportSpecific to 0x1` to make phc2sys work

```
transportspecific  0x1
```


## On the Sender Node (e.g., BeagleBone Black )

1. You can change `slaveOnly` option to 1 on the slaves and reduce priority
```
slaveonly        1
priority1		255
priority2		255
```

2. Run as PTP slave:

```
sudo ptp4l -i eth0  -p /dev/ptp0 -s -m -2 > /var/log/ptp4l.log 2>&1 & 
sudo phc2sys -s eth0 -c CLOCK_REALTIME -O 0 -m > /var/log/phc2sys.log 2>&1 & 
```

---

## For NXP Boards (Sender):
```
sudo ptp4l -i swp0 -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log
sudo phc2sys -s swp0 -c CLOCK_REALTIME -O 0 -m > /var/log/phc2sys.log 2>&1 & 
```

## On the TSN Switch (LS1028A-RDB)


Run `ptp4l` on each switch port:

```
ptp4l -i swp0 -i swp1 -i swp2 -i swp3 -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log 2>&1 &
sudo phc2sys -s swp1 -c CLOCK_REALTIME -O 0 -m > /var/log/phc2sys.log 2>&1 & 
```
Note you should use -2 option because of the bridge setting. You can run phc2sys on any active port running ptp4l on the switch.


## On the Receiver Node (LS1028A-RDB or PC)

Run:
```
ptp4l -i swp1  -p /dev/ptp1 -f /etc/ptp4l_cfg/default.cfg -m -2 > /var/log/ptp4l.log 2>&1 &
sudo phc2sys -s swp1 -c CLOCK_REALTIME -O 0 -m > /var/log/phc2sys.log 2>&1 & 
```


## Troubleshooting

| Problem                          | Solution                                  |
| -------------------------------- | ----------------------------------------- |
| `No clock found `                | Try changing /dev/ptp1 to /dev/ptp0       |
| `binding to udp socket failed`   | Make sure no other ptp4l instance runs    |
| `Timeout error`                  | Increase the ttx_timestamp_timeout        |
| Permission denied                | Run commands with `sudo`                  |

---
You might need to run the scripts/ ptp-trap for extra configuration on the enetc ports on LS1028a. See the NXP Real-time edge software user guide documentation.

## References

* IEEE 1588-2008 Standard
* NXP LS1028A Documentation

