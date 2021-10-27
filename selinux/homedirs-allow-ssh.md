# Enable ssh for homes in alternative locations
selinux prevents ssh login with publickey unless you do this for ssh.

    semanage fcontext -a -t ssh_home_t /lhome/ubuntu/.ssh/authorized_keys
    semanage fcontext -a -t ssh_home_t /lhome/ubuntu/.ssh
    restorecon -R -v /lhome/ubuntu/.ssh/
