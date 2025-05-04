# -If you are using GCP, add firewall in networking in gcp and set it for the vm  instance. UPD with port 51820

# -Windows network config in powershell adminNew-NetFirewallRule -DisplayName "Allow WireGuard" -Direction Inbound -InterfaceAlias "<windows client interface>" -Action Allow

# -netsh advfirewall firewall add rule name="Allow ICMPv4" protocol=icmpv4 dir=in action=allow
# -To check packetssudo tcpdump -i wg0
# -Also in relay server add this /etc/sysctl.conf and add:
# -net.ipv4.ip_forward=1Also run this command
# -sudo ip route add 10.0.0.0/24 dev wg0sudo iptables -A FORWARD -i wg0 -o wg0 -j ACCEPTsudo ----iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  ( automatically addin in network server )

# Also makesure you put 
# -sudo ip link set dev wg0 mtu 1200  
# If ssh fails at the 
# debug1: expecting SSH2_MSG_KEX_ECDH_REPLY in verbose ssh

# also add this command
# sudo iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE ( this also should be put in network server directly )
# sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE

#!/bin/bash

set -e

echo "[*] Installing WireGuard..."
sudo apt install -y wireguard

echo "[*] Verifying installation..."
if command -v wg > /dev/null && command -v wg-quick > /dev/null; then
    echo "[✓] WireGuard installed and ready to use."
else
    echo "[!] WireGuard installation failed."
    exit 1
fi
