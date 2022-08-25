# SSH & DDNs
How to login to a Unifi Dream Machine Pro from a Ubuntu 22.04 linux client to the UDMPro which requres some SSH settings.

How to manually run the DDNS update.

## Login with SSH
Assuming you normally login to your device on lets say 192.168.1.1. You need to use the *root* account.

    ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa root@192.168.1.1


## Run inadyn
To force a reconfiguration of the DDNS.

The application that updates the remote DNS provider is "inadyn". 
It calls a remote API in your account to update a A+ DDNS record.

The configuration is located at **/run/ddns-eth8-inadyn.conf**

Mine looks like this:

```
# Generated automatically by ubios-udapi-server
#
iface = eth8

custom namecheap.0:1 {
    hostname = "@"
    username = "lonroth.net"
    password = "XXXXXXXXXXXXXXXXXXXXXXXXX"
    ddns-server = "dynamicdns.park-your-domain.com"
    ddns-path = "/update?domain=lonroth.net&password=XXXXXXXXXXXXXXXXXXXXXXXXX&host="
}
```

After logging in to the UDMPro, run the following:

    inadyn -n -s -C -f /run/ddns-eth8-inadyn.conf  -1 -l debug --foreground
    
You should see something like this in the end:

    inadyn[20766]: Successful alias table update for @ => new IP# 13.5.10.17
    inadyn[20766]: Updating cache for @

