# Production setup LXD
Based on https://linuxcontainers.org/lxd/docs/master/production-setup

## Networking on host
– For a 1Gb/s network and Rount Trip Time of 0.1s, the BDP=(0.1 * 10^9)/8. On such a network, set the following parameter values under the file : /etc/sysctl.conf

### Network related params
    net.core.rmem_max = 12500000
    net.core.wmem_max = 12500000
    net.ipv4.tcp_rmem = 4096 87380 12500000
    net.ipv4.tcp_wmem = 4096 65536 12500000
    net.core.netdev_max_backlog = 30000
    net.ipv4.tcp_max_syn_backlog = 4096

## /etc/sysctl.d/99-lxd.conf 
Setting so far on a 1G network.

    fs.aio-max-nr = 524288
    fs.inotify.max_queued_events = 1048576
    fs.inotify.max_user_instances = 1048576
    fs.inotify.max_user_watches = 1048576
    kernel.dmesg_restrict = 1
    kernel.keys.maxbytes = 2000000
    kernel.keys.maxkeys = 2000
    net.core.bpf_jit_limit = 3000000000
    net.ipv4.neigh.default.gc_thresh3 = 8192
    net.ipv6.neigh.default.gc_thresh3 = 8192
    net.core.rmem_max = 12500000
    net.core.wmem_max = 12500000
    net.ipv4.tcp_rmem = 4096 87380 12500000
    net.ipv4.tcp_wmem = 4096 65536 12500000
    net.core.netdev_max_backlog = 30000
    net.ipv4.tcp_max_syn_backlog = 4096
    vm.max_map_count = 262144

