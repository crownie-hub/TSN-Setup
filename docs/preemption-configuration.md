
## To set preemption on

To ensure **preemption and Time-Sensitive Networking (TSN)** work correctly across the testbed, follow these steps on **all devices** (Sender, Switch, and Receiver):

---

### Set Ethernet Speed to 1 Gbit/s on both the switch and the reciever

Run this on **each interface** :

```bash
sudo ethtool -s <interface> speed 1000 duplex full autoneg on
```

* Replace `<interface>` with your actual interface name (e.g., `swp0`, `eno0`, or `eth0`).

 **Remember to set  on:**

* LS1028A Switch
* LS1028A Receiver 

---

### Enable MAC Merge and Preemption both on TSN switch and Receiver

On the **interface**, enable MAC Merge and preemption:

```bash
sudo ethtool --set-mm swp0 tx-enabled on pmac-enabled on
```


You can verify it's enabled with:

```bash
 ethtool --show-frame-preemption eth1
```

### Set Preemption Mask with `tsntool` or with ethtool

Use `tsntool` to configure queue preemptability (bitmask format):

```bash
sudo tsntool qbuset --device swp1 --preemptable 0x25
```
### or With ethtool
```bash
ethtool --set-frame-preemption swp1 fp on preemptible-queues-mask 0x25 min-fragsize 60
```
The bitmask `0x25` means queues 0, 2, and 5 are preemptable.
Refer to this bit-position mapping:


| Queue | Bit | Value |
| ----- | --- | ----- |
| q0    | 0   | 0x01  |
| q1    | 1   | 0x02  |
| q2    | 2   | 0x04  |
| q3    | 3   | 0x08  |
| q4    | 4   | 0x10  |
| q5    | 5   | 0x20  |
| q6    | 6   | 0x40  |
| q7    | 7   | 0x80  |

---

### Send frames and confirm  premeption with 

```bash
ethtool --show-mm swp0 | grep MACMergeFragCountTx
```
You should see a non-zero counter, confirming that merge frames are being used.


