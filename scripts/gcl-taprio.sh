tc qdisc replace dev swp1 parent root taprio \
num_tc 8 \
map 0 1 2 3 4 5 6 7 \
queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
base-time 0 \
sched-entry S 0x0f 1000000 \
flags 0x2
