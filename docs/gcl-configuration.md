That `tc qdisc` command is configuring a **Time-Aware Shaper (TAS)** using `taprio`, which is essential in TSN for scheduling transmission gates based on time. This belongs in a GCL (Gate Control List) configuration documentation file.


# Gate Control List (GCL) Configuration using `taprio`

This guide shows how to configure Time-Aware Scheduling (TAS) on the LS1028A's Ethernet ports using the `taprio` qdisc. This setup enforces time-based transmission windows for queues on the egress port to the receiver, for example, if receiver node is connected to  `swp1` on the switch.

---

## Example: Create a bash script and configure `taprio` on `swp1`

```bash
sudo tc qdisc replace dev swp1 parent root taprio \
  num_tc 8 \
  map 0 1 2 3 4 5 6 7 \
  queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
  base-time 0 \
  sched-entry S 0x0f 1000000 \
  flags 0x2
```

### Explanation of Parameters:

| Parameter                    | Meaning                                                                 |
| ---------------------------- | ----------------------------------------------------------------------- |
| `dev swp1`                   | Target interface                                                        |
| `num_tc 8`                   | Number of traffic classes (0–7)                                         |
| `map 0 1 2 3 4 5 6 7`        | Maps traffic classes to priorities (1:1 mapping)                        |
| `queues 1@0 ... 1@7`         | Assigns 1 queue per traffic class                                       |
| `base-time 0`                | Starting time of the schedule (0 = now, or replace with actual ns time) |
| `sched-entry S 0x0f 1000000` | Schedules gates 0–3 (0x0f = 00001111) open for 1 ms (1,000,000 ns)      |
| `flags 0x2`                  | Enable hardware offloading (TSN)                                        |

---
Using the `tsntool` command on LS1028a board, you can replace `base-time 0` with a future time in nanoseconds to align with your PTP-synchronized clock. You can set it using:

  ```bash
  tsntool ptptool -g
  ```

* If multiple entries are needed (e.g., a cyclic GCL), chain `sched-entry` lines:

  ```bash
  sched-entry S 0x01 100000 \
  sched-entry S 0x02 100000 \
  sched-entry S 0x04 100000 \
  ```

* `0x0f` opens gates for priorities 0–3; to schedule specific queues, change the bitmask.

---

### Verify the qdisc

```bash
tc -s qdisc show dev swp1
```

---


Each bit in the mask corresponds to a queue (priority) from 0 to 7:

```
Bitmask:  0b76543210
Queues:     7 6 5 4 3 2 1 0
```

### Single Priority Bitmasks

| Priority (Queue) | Bit Position | Bitmask (Hex) |
| ---------------- | ------------ | ------------- |
| 0                | 2⁰           | `0x01`        |
| 1                | 2¹           | `0x02`        |
| 2                | 2²           | `0x04`        |
| 3                | 2³           | `0x08`        |
| 4                | 2⁴           | `0x10`        |
| 5                | 2⁵           | `0x20`        |
| 6                | 2⁶           | `0x40`        |
| 7                | 2⁷           | `0x80`        |

