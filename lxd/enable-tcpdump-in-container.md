
# Enable tcpdump in an LXC container

Ubuntu LXC containers do not allow the usage of tcpdump by default. As a result the tcpdump command exits silently with exit code 1.

As can be seen from output of dmesg, this behaviour is enforced by AppArmor.

To enable temporarily tcpdump, the following commands can be used:

    apt install apparmor-utils
    aa-complain /usr/sbin/tcpdump

Then tcpdump should work as normally. Then to restore the original behaviour:

    aa-enforce /usr/sbin/tcpdump

