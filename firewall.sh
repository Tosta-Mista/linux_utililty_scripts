#!/bin/bash
#
# Author : José Gonçalves
# Version : 1.2
#
# References:
#  http://www.newartisans.com/blog_files/tricks.with.iptables.php
clear;
echo "#============================================================================#"
echo "# FIREWALL SCRIPT                                                            #"
echo "#============================================================================#"
echo "# Version 1.2  #"
echo "#==============#"
echo "






"
echo "#========================= SETTING UP RULES =================================#"
# Wipe the tables clean
iptables -F
echo "Wipe the tables clean : [OK]"

# INPUT SIDE
echo "#======================== INPUT SIDE =====================#"
# Accept all loopback input
iptables -A INPUT -i lo -p all -j ACCEPT
echo "Accept all loopback input : [OK]"

# Allow the three way handshake
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "Allow the three way handshake : [OK]"
echo "#======================= SECURITY RULES ==================#"
# Reject spoofed packets
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP

iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -d 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -d 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255 -j DROP
echo "Reject spoofed packets : [OK]"

# Stop smurf attacks
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp -m icmp -m limit --limit 1/second -j ACCEPT
echo "Stop smurf attacks : [OK]"

# Drop all invalid packets
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
echo "Drop all invalid packets : [OK]"

# Drop excessive RST packets to avoid smurf attacks
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
echo "Drop excessive RST packets to avoid smurf attacks : [OK]"

# Attempt to block portscans
# Anyone who tried to portscan us is locked out for an entire day.
iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP
echo "Attemp to block portscan 1/3 : [OK]"

# Once the day has passed, remove them from the portscan list
iptables -A INPUT   -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove
echo "Attemp to block portscan 2/3 : [OK]"

# These rules add scanners to the portscan list, and log the attempt.
iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
echo "Attemp to block portscan 3/3 : [OK]"

echo "#========================= INPUT RULES =======================================#"
# Allow the following ports through from outside
# smtp
iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
echo "Allow smtp : [OK]"

# SSH
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
echo "Allow SSH : [OK]"

# http
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
echo "Allow http : [OK]"

# https
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
echo "Allow https : [OK]"

# django
iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
echo "Allow Django server : [OK]"

# Allow pings through
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
echo "Allow Ping : [OK]"

# Kill all other input
iptables -A INPUT -j REJECT
echo "Kill all other input : [OK]"

echo "#========================= OUTPUT RULES =====================================#"
# Output side
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "Default output rules : [OK]"

# Allow the following ports through from outside
# FTP
iptables -A OUTPUT -p tcp -m tcp --dport 21 -j ACCEPT
echo "Allow FTP : [OK]"

# SSH and SFTP
iptables -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 6060 -j ACCEPT
echo "Allow SSH and SFTP : [OK]"

# smtp
iptables -A OUTPUT -p tcp -m tcp --dport 25 -j ACCEPT
echo "Allow smtp : [OK]"

# DNS requests
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
echo "Allow DNS : [OK]"

# DHCP/Bootstrap Protocol Server
iptables -A OUTPUT -p udp -m udp --dport 67 -j ACCEPT
echo "Allow DHCP/BootStrap : [OK]"

# http
iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
echo "Allow http : [OK]"

# pop3
iptables -A OUTPUT -p tcp -m tcp --dport 110 -j ACCEPT
echo "Allow pop3 : [OK]"

# imap
iptables -A OUTPUT -p tcp -m tcp --dport 143 -j ACCEPT
echo "Allow imap : [OK]"

# https
iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
echo "Allow https : [OK]"

# imaps
iptables -A OUTPUT -p tcp -m tcp --dport 993 -j ACCEPT
echo "Allow imaps : [OK]"

# pop3s
iptables -A OUTPUT -p tcp -m tcp --dport 995 -j ACCEPT
echo "Allow pop3s : [OK]"

# ssh & sftp
iptables -A OUTPUT -p tcp -m tcp --dport 6060 -j ACCEPT
echo "Allow SSH : [OK]"

# snmp
iptables -A OUTPUT -p tcp -m tcp --dport 161 -j ACCEPT
echo "Allow SNMP : [OK]"

# Django
iptables -A OUTPUT -p tcp -m tcp --dport 8080 -j ACCEPT
echo "Allow Django server : [OK]"

# Allout pings out
iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
echo "Allow Ping Out : [OK]"

# SSH Special rules :
iptables -t filter -A INPUT -p tcp --dport 6060 -m recent --rcheck --seconds 60 --hitcount 2 --name SSH -j LOG --log-prefix "SSH REJECT"
iptables -t filter -A INPUT -p tcp --dport 6060 -m recent --update --seconds 60 --hitcount 2 --name SSH -j DROP
iptables -t filter -A INPUT -p tcp --dport 6060 -m state --state NEW -m recent -set -name SSH -j ACCEPT
echo "Regles spÃ©ciales SSH : [OK]"
# Kill all other output
iptables -A OUTPUT -j REJECT
echo "Kill All Output : [OK]"

# FORWARD SIDE
iptables -A FORWARD -j REJECT

echo "#======================== SAVING RULES ======================================#"
iptables-save
echo "#All done... Closing script... "

exit 0;