# Moving files in a lxd host

* scp is fine but probably the slowest option
* A shared custom volume could be a way (lxc storage volume create and lxc storage volume attach)
* Directly copy/move files as root through /var/snap/lxd/common/mntns/var/snap/lxd/common/lxd/storage-pools/
