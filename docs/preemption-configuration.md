
## To set preemption on

To ensure **preemption** work correctly across the testbed, follow these steps:

---

### Set Ethernet Speed to 1 Gbit/s on both the switch and the reciever

Run this on **each interface** :

```bash
sudo ethtool -s <interface> speed 1000 duplex full autoneg on
```

* Replace `<interface>` with your actual interface name (e.g., `swp1`), for the both port connecting the switch to the receiver and vice versa

 **Remember to set  on:**

* LS1028A Switch
* LS1028A Receiver 

---

### Enable MAC Merge and Preemption both on TSN switch and Receiver

On the **interface**, enable MAC Merge and preemption:

```bash
sudo ethtool --set-mm <interface> tx-enabled on pmac-enabled on
```


You can verify it's enabled with:

```bash
 ethtool --show-frame-preemption <interface>
```

### Set Preemption Mask with `tsntool` or with ethtool on the Switch.

Use `tsntool` to configure queue preemptability (bitmask format):

```bash
sudo tsntool qbuset --device <interface> --preemptable 0x25
```
### or With ethtool
```bash
ethtool --set-frame-preemption <interface> fp on preemptible-queues-mask 0x25 min-fragsize 60
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

### Send frames and confirm preemption works on the switch with: 

```bash
ethtool --show-mm <interface> | grep MACMergeFragCountTx
```
You should see a non-zero counter, confirming that merge frames are being used.


