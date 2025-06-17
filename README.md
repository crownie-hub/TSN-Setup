## Getting Started

To set up your TSN testbed with the LS1028A-RDB board and other hardware, follow the steps below in order. Each markdown or script file in this repository is designed to handle a specific part of the configuration:

### 📁 Repository Structure

| Folder/File                                                                                                 | Description                                                               |
| ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [`README.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/README.md)                                 | Overview and instructions on how to use this repository                   |
| [`docs/setup-guide.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/docs/setup-guide.md)             | Full setup guide for flashing the board and connecting a sample network   |
| [`docs/ptp-configuration.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/docs/ptp-configuration.md) | Instructions and script to set up PTP synchronization (grandmaster/slave) |
| [`docs/network-config.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/docs/network-config.md)       | Steps and script to configure ports, VLANs, and bridges                   |
| [`docs/gcl-configuration.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/docs/gcl-configuration.md) | Configure Time-Aware Shaper (TAS) using `tc taprio` with GCL schedules    |
| [`scripts/test-all-prio.py`](https://github.com/crownie-hub/TSN-Setup/blob/main/scripts/test-all-prio.py)   | Python script using Scapy to send prioritized Ethernet frames             |
| [`docs/preemption-config.md`](https://github.com/crownie-hub/TSN-Setup/blob/main/docs/preemption-config.md) | Configure MAC Merge and Frame Preemption using `ethtool` and `tsntool`    |
| [`scripts/switch.sh`](https://github.com/crownie-hub/TSN-Setup/blob/main/scripts/switch.sh)                 | Bash script for automating network configuration                          |
| [`scripts/ptp-trap.sh`](https://github.com/crownie-hub/TSN-Setup/blob/main/scripts/ptp-trap.sh)             | Bash script for automating PTP master/slave role setup                    |

---


###  Order

 **Step 1. Set and bring up interfaces**
   → Follow `setup-guide.md` and `network-config.md`
   → Flash image, bring up interfaces, set IPs .

 **Step 2. Configure VLANs and Bridge**
   → Use `network-config.md`
   → Add ports to bridge, assign VLANs.

 **Step 3. Enable PTP Synchronization**
   → See `ptp-configuration.md`
   → Choose role: master (LS1028A), slave (end node).

 **Step 4. Enable GCL Schedule (TAS)**
   → Use `gcl-configuration.md`
   → Set up queue scheduling with `tc qdisc taprio`.

 **Step 5. Enable Frame Preemption (Optional)**
   → See `preemption-config.md`
   → Use `ethtool` and `tsntool`.

 **Step 6. Send Prioritized Traffic**
   → Run `test-all-prio.py` or  `send-vlan.py` 
   → Simulate traffic of different priorities.

See the full ptp configuration for the master and slaves in `config/master_default.cfg` and `config/slave_default.cfg` for LS1028A

## References

* IEEE 1588-2008 Standard
* NXP LS1028A Real-time edge Software user guide

