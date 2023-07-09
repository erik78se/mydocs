Setup ssh such as that it only allows rsync and not login.

# setup authorized_keys for user foo
    cat .ssh/authorized_keys
    command="/usr/bin/rrsync /tmp/" ssh-rsa AAAAB3NzaC1y.....= foo@juju-2960b5-0

# ssh shouldnt work
    ssh -i id_rsa -o IdentitiesOnly=yes foo@192.168.2.212
    
# rsync your test file
rsync -auve 'ssh -i /home/erik/rrsync/id_rsa -o IdentitiesOnly=yes' test foo@192.168.2.212:

# Setup /etc/rsyncd.conf

cat /etc/rsyncd.conf

    [backups]
    path = /home/ubuntu/backups/
    hosts allow = 192.168.111.142/32
    hosts deny = *
    list = true
    uid = ubuntu
    gid = ubuntu
    read only = false
    use chroot = false
