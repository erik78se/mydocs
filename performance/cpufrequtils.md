# Disable ondemand and configure scaling_govenor
Prevent CPU to go down in performance... May cause throttling events. Check fans.

READ also: https://ixnfo.com/en/changing-cpu-scaling-governor-on-linux.html

BIOS must allow the OS to assume control over this. For example on HPE servers 
in the BIOS, you must enable Collaborative Power Control (CPC). It might be different on other servers.

###  Let’s see the current value of all processor cores:

    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    ls /sys/devices/system/cpu/

In my case, the default value for all eight cores is “ondemand”.

### Let’s look at possible schemes:
	
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors

## Disable ondemand

    sudo systemctl stop ondemand
    sudo systemctl disable ondemand

## Set scaling_governor
    sudo apt install cpufrequtils
    echo "GOVERNOR=performance"| sudo tee /etc/default/cpufrequtils
    sudo systemctl restart cpufrequtils

