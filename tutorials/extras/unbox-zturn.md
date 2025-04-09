# Initial setup of Z-turn connection

### My Setup
- Board: `MYS-7Z010/20-V2`
- Computer: `MacBook Air`
- OS: `macOS Sonoma 14.6.1`

### Checking pre-installed Linux version
- If Linux is installed and boots successfully, there will be a login prompt when connecting to the Z-turn. Can check the kernel version and type of system with
```bash
uname -a
```
- The Z-turn information is 
```
Linux zturn 4.14.0-xilinx-v2018.3 #2 SMP PREEMPT Thu Dec 22 06:58:21 UTC 2022 armv7l armv7l armv7l GNU/Linux
```

### Getting IP adddess
```bash
ifconfig
```
- This shows the ethernet interface `eth0` and the loopback interface `lo`. There is no wireless interface `wlan0`
- Connect Z-turn to a wall socket network port with an ethernet cable
```
root@zturn:~# random: crng init done
macb e000b000.ethernet eth0: link up (1000/Full)
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
```
- This means the Z-turn successfully detected the ethernet connection and brought the network interface up. 
- `macb e000b000.ethernet eth0: link up (1000/Full)` means the ethernet interface `eth0` has established a link with the netwrok at a speed of 1000 Mbps/ 1 Gbps and it is in full-duplex mode, meaning it can send and recieve data simultaneously.
- `IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready` means `eth0` is configured, and ready for IPv6 traffic. `IPv4` and `IPv6` are two versions of internet protocol: rules for routing and addressing data so it can travel across networksand reach the correct destination. IPv4 uses 32 bits, so there is a limited number of addresses. It is typically written in decimal form, and divided into four octets like `192.168.0.1`. IPv6 is the successor and uses 128 bits so it has many more addresses. It is typically written in hexadecimal and divided into eight 16 bit blocks like `2001:0db8:85a3:0000:0000:8a2e:0370:7334`
- Need to make sure the Z-turn also received an `IPv4` address, because that is usually what you want for networking tasks
```bash
ifconfig eth0
```
- Look for a line that starts with `inet addr` and is followed by an IP address

### Testing network connection
- Once an IPv4 address is assigned, you can test the network connection by pinging an external website or another device on the same network:
```bash
ping google.com
```

### Check default gateway and DNS
To ensure you can reach external networks
```bash
route -n
```
There should be a route with the destination `0.0.0.0`. This is the default gateway pointing to the network's gateway IP.
```bash
cat /etc/resolv/conf
```
Ensure this contains a valid DNS server address

### Setting up SSH
- Trying to SSH in immediately from your compter may cause errors becuase `ssh-rsa`, a specific public key algorithm used within the SSH protocol for authentification, is old and automatically disabled on modern clients.
```bash
Unable to negotiate with 128.91.41.181 port 22: no matching host key type found. Their offer: ssh-rsa
```
- So we permanently allow `ssh-rsa` for this host by opening the SSH config file `~/.ssh/config` and adding a host-specific entry
```plaintext
Host 128.91.41.181
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedAlgorithms +ssh-rsa
```
- If hostkey changes and you can't connect try again after removing the hostkey
```bash
ssh-keygen -f "/home/hep/.ssh/known_hosts" -R "128.91.42.95"
```
### Other
- This should be the `/etc/network/interfaces` file
```bash
# /etc/network/interfaces -- configuration file for ifup(8), ifdown(8)
 
# The loopback interface
auto lo
iface lo inet loopback

# Wireless interfaces
iface wlan0 inet dhcp
	wireless_mode managed
	wireless_essid any
	wpa-driver wext
	wpa-conf /etc/wpa_supplicant.conf

iface atml0 inet dhcp

# Wired or wireless interfaces
auto eth0
iface eth0 inet dhcp
iface eth1 inet dhcp

# Ethernet/RNDIS gadget (g_ether)
# ... or on host side, usbnet and random hwaddr
iface usb0 inet static
	address 192.168.7.2
	netmask 255.255.255.0
	network 192.168.7.0
	gateway 192.168.7.1

# Bluetooth networking
iface bnep0 inet dhcp
```
