# ZFS

## Designing zfs storage:
https://www.ixsystems.com/blog/zfs-pool-performance-1/


Assumptions:
 * NVME disks only

## Basic performance test
    zfs create -o mountpoint=/mnt/benchmarks mypool/benchmarks

    fio --name=seqread --rw=read --direct=0 --ioengine=libaio --bs=1M --numjobs=10 --size=10G --runtime=600 --group_reporting
 
## Caching
 zfs with nvme and for lxd containers can turn off caching since SSD disks are  equally fast across the whole surface.
 
 "It is possible to improve performance when a zvol or dataset hosts an application that does its own caching by caching only metadata. One example is PostgreSQL. Another would be a virtual machine using ZFS."

Would it make sense to set caching to metadata only?:
    
    zfs list -o name,filesystem_limit,primarycache,secondarycache | grep -E juju-46be60-0
    zfs set primarycache=metadata  lxdhosts/containers/juju-46be60-0
    zfs set secondarycache=metadata  lxdhosts/containers/juju-46be60-0


## Block size
Using correct block size? (512 vs 4096)

    sudo stat -f /dev/nvme0n1
    sudo parted -l physical/logical
    cat /sys/block/nv*/queue/hw_sector_size
    cat /sys/block/nv*/queue/physical_block_size

### nvms-cli (inspect nvme drives)  

    apt install nvme-cli
    nvme list

### Kernel settings recommended for lxd production
cat /etc/sysctl.d/99-lxd.conf
```
fs.aio-max-nr = 524288
fs.inotify.max_queued_events = 1048576
fs.inotify.max_user_instances = 1048576
fs.inotify.max_user_watches = 1048576
kernel.dmesg_restrict = 1
kernel.keys.maxbytes = 2000000
kernel.keys.maxkeys = 2000
net.core.bpf_jit_limit = 3000000000
net.core.netdev_max_backlog = 182757
net.ipv4.neigh.default.gc_thresh3 = 8192
net.ipv6.neigh.default.gc_thresh3 = 8192
vm.max_map_count = 262144
```
```
### More recommented security for lxd
chmod 400 /proc/sched_debug
chmod 700 /sys/kernel/slab/
```
# Tuning zfs for lxdhost

https://openzfs.readthedocs.io/en/latest/performance-tuning.html
